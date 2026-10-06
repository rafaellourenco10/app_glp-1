-- Companheiro GLP-1 — schema inicial.
-- Toda tabela do usuário referencia auth.users com ON DELETE CASCADE:
-- apagar o usuário no Auth apaga todos os dados dele.

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  name text not null,
  birth_year smallint check (birth_year between 1900 and 2100),
  height_cm numeric check (height_cm > 0),
  protein_goal_g numeric not null check (protein_goal_g > 0),
  consented_at timestamptz not null, -- aceite LGPD + disclaimer
  created_at timestamptz not null default now()
);

create table public.treatments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  medication text not null check (medication in ('Ozempic','Wegovy','Mounjaro','Zepbound','Saxenda','Outro')),
  dose_label text not null,
  weekday smallint not null check (weekday between 1 and 7), -- ISO: 1=seg ... 7=dom
  time_of_day time not null,
  active boolean not null default true,
  started_on date not null default current_date
);

create table public.dose_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  treatment_id uuid references public.treatments (id) on delete set null,
  taken_at timestamptz not null default now(),
  dose_label text not null,
  site text check (site in ('abdomen','coxa','braco')),
  note text
);

create table public.foods (
  id serial primary key,
  name text not null,
  portion_label text not null,
  protein_g numeric not null check (protein_g >= 0)
);

create table public.protein_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  logged_at timestamptz not null default now(),
  food_id int references public.foods (id),
  label text not null,
  qty numeric not null default 1 check (qty > 0),
  protein_g numeric not null check (protein_g >= 0) -- total já multiplicado pela qty
);

create table public.symptom_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  logged_at timestamptz not null default now(),
  symptom text not null,
  severity smallint not null check (severity between 0 and 3),
  note text
);

create table public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  logged_at timestamptz not null default now(),
  kg numeric not null check (kg > 0 and kg < 500)
);

create table public.workout_templates (
  id serial primary key,
  name text not null,
  level text not null,    -- 'iniciante' | 'intermediario'
  location text not null  -- 'casa' | 'academia'
);

create table public.workout_template_exercises (
  id serial primary key,
  template_id int not null references public.workout_templates (id) on delete cascade,
  position smallint not null,
  name text not null,
  sets smallint not null,
  reps text not null,
  note text,
  url text
);

create table public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  template_id int references public.workout_templates (id),
  done_at timestamptz not null default now()
);

create table public.workout_session_exercises (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.workout_sessions (id) on delete cascade,
  exercise_name text not null,
  done boolean not null default false
);

create index on public.dose_logs (user_id, taken_at);
create index on public.protein_logs (user_id, logged_at);
create index on public.symptom_logs (user_id, logged_at);
create index on public.weight_logs (user_id, logged_at);
create index on public.workout_sessions (user_id, done_at);
create index on public.workout_session_exercises (session_id);

-- RLS -----------------------------------------------------------------------

alter table public.profiles enable row level security;
alter table public.treatments enable row level security;
alter table public.dose_logs enable row level security;
alter table public.foods enable row level security;
alter table public.protein_logs enable row level security;
alter table public.symptom_logs enable row level security;
alter table public.weight_logs enable row level security;
alter table public.workout_templates enable row level security;
alter table public.workout_template_exercises enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.workout_session_exercises enable row level security;

create policy own on public.profiles for all to authenticated
  using (auth.uid() = id) with check (auth.uid() = id);
create policy own on public.treatments for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own on public.dose_logs for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own on public.protein_logs for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own on public.symptom_logs for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own on public.weight_logs for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own on public.workout_sessions for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own on public.workout_session_exercises for all to authenticated
  using (exists (select 1 from public.workout_sessions s where s.id = session_id and s.user_id = auth.uid()))
  with check (exists (select 1 from public.workout_sessions s where s.id = session_id and s.user_id = auth.uid()));

-- Catálogos: leitura pública, sem política de escrita => cliente não escreve.
create policy read_all on public.foods for select to anon, authenticated using (true);
create policy read_all on public.workout_templates for select to anon, authenticated using (true);
create policy read_all on public.workout_template_exercises for select to anon, authenticated using (true);

-- RPCs ----------------------------------------------------------------------

-- Apaga o usuário do Auth; o cascade remove todas as linhas dele.
create function public.delete_my_account()
returns void
language sql
security definer
set search_path = ''
as $$
  delete from auth.users where id = auth.uid();
$$;
revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Exporta todos os dados do usuário em JSON (security invoker: RLS se aplica).
create function public.export_my_data()
returns json
language sql
stable
set search_path = ''
as $$
  select json_build_object(
    'profile', (select row_to_json(p) from public.profiles p),
    'treatments', (select coalesce(json_agg(t), '[]') from public.treatments t),
    'dose_logs', (select coalesce(json_agg(d order by d.taken_at), '[]') from public.dose_logs d),
    'protein_logs', (select coalesce(json_agg(x order by x.logged_at), '[]') from public.protein_logs x),
    'symptom_logs', (select coalesce(json_agg(x order by x.logged_at), '[]') from public.symptom_logs x),
    'weight_logs', (select coalesce(json_agg(x order by x.logged_at), '[]') from public.weight_logs x),
    'workout_sessions', (select coalesce(json_agg(json_build_object(
        'done_at', s.done_at, 'template_id', s.template_id,
        'exercises', (select coalesce(json_agg(e), '[]') from public.workout_session_exercises e where e.session_id = s.id)
      ) order by s.done_at), '[]') from public.workout_sessions s)
  );
$$;
revoke execute on function public.export_my_data() from public, anon;
grant execute on function public.export_my_data() to authenticated;
