-- Prova de isolamento entre usuários (RLS) e de exclusão de conta.
-- Rode como superusuário (SQL Editor do Supabase, ou psql na connection string).
-- Tudo roda numa transação com ROLLBACK: não deixa lixo no banco.
-- Sucesso = termina com "NOTICE: RLS OK" e "NOTICE: EXCLUSAO OK". Qualquer falha aborta com "FALHA: ...".

begin;

-- Dois usuários fictícios.
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'a@teste.local'),
  ('00000000-0000-0000-0000-00000000000b', 'b@teste.local');

-- Dados do usuário B (inseridos como superusuário, ignorando RLS).
insert into public.profiles (id, name, protein_goal_g, consented_at)
  values ('00000000-0000-0000-0000-00000000000b', 'B', 90, now());
insert into public.treatments (id, user_id, medication, dose_label, weekday, time_of_day)
  values ('00000000-0000-0000-0000-0000000000f1', '00000000-0000-0000-0000-00000000000b', 'Outro', '1 mg', 1, '20:00');
insert into public.dose_logs (user_id, dose_label) values ('00000000-0000-0000-0000-00000000000b', '1 mg');
insert into public.protein_logs (user_id, label, protein_g) values ('00000000-0000-0000-0000-00000000000b', 'Ovo', 6);
insert into public.symptom_logs (user_id, symptom, severity) values ('00000000-0000-0000-0000-00000000000b', 'nausea', 1);
insert into public.weight_logs (user_id, kg) values ('00000000-0000-0000-0000-00000000000b', 80);
insert into public.workout_sessions (id, user_id) values ('00000000-0000-0000-0000-0000000000f2', '00000000-0000-0000-0000-00000000000b');
insert into public.workout_session_exercises (session_id, exercise_name, done)
  values ('00000000-0000-0000-0000-0000000000f2', 'Agachamento', true);

-- Agora age como o usuário A, autenticado.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-00000000000a","role":"authenticated"}', true);
select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-00000000000a', true); -- versões antigas de auth.uid()

do $$
declare
  t text;
  n int;
begin
  if auth.uid() is distinct from '00000000-0000-0000-0000-00000000000a' then
    raise exception 'FALHA: sessão simulada não funcionou (auth.uid() = %)', auth.uid();
  end if;

  -- 1) A não LÊ nada de B.
  foreach t in array array['profiles','treatments','dose_logs','protein_logs','symptom_logs',
                           'weight_logs','workout_sessions','workout_session_exercises'] loop
    execute format('select count(*) from public.%I', t) into n;
    if n <> 0 then raise exception 'FALHA: A leu % linha(s) de B em %', n, t; end if;

    -- 2) A não ALTERA nem APAGA nada de B (RLS filtra: 0 linhas afetadas).
    execute format('delete from public.%I', t);
    get diagnostics n = row_count;
    if n <> 0 then raise exception 'FALHA: A apagou % linha(s) de B em %', n, t; end if;
  end loop;

  update public.weight_logs set kg = 1;
  get diagnostics n = row_count;
  if n <> 0 then raise exception 'FALHA: A alterou peso de B'; end if;

  -- 3) A não ESCREVE em nome de B.
  begin
    insert into public.weight_logs (user_id, kg) values ('00000000-0000-0000-0000-00000000000b', 70);
    raise exception 'FALHA: A inseriu peso em nome de B';
  exception when insufficient_privilege then null; -- 42501: bloqueado pela RLS
  end;
  begin
    insert into public.workout_session_exercises (session_id, exercise_name)
      values ('00000000-0000-0000-0000-0000000000f2', 'Intruso');
    raise exception 'FALHA: A inseriu exercício na sessão de B';
  exception when insufficient_privilege then null;
  end;

  -- 4) A não escreve nos catálogos.
  begin
    insert into public.foods (name, portion_label, protein_g) values ('x', 'x', 1);
    raise exception 'FALHA: cliente escreveu em foods';
  exception when insufficient_privilege then null;
  end;

  -- 5) A consegue escrever os PRÓPRIOS dados (user_id preenchido por default = auth.uid()).
  insert into public.weight_logs (kg) values (70);
  select count(*) into n from public.weight_logs;
  if n <> 1 then raise exception 'FALHA: A não vê o próprio registro'; end if;

  raise notice 'RLS OK';
end $$;

-- Agora B exclui a própria conta.
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-00000000000b","role":"authenticated"}', true);
select set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-00000000000b', true); -- versões antigas de auth.uid()
select public.delete_my_account();

reset role;

do $$
declare
  t text;
  n int;
begin
  select count(*) into n from auth.users where id = '00000000-0000-0000-0000-00000000000b';
  if n <> 0 then raise exception 'FALHA: usuário B ainda existe no Auth'; end if;
  foreach t in array array['treatments','dose_logs','protein_logs','symptom_logs','weight_logs','workout_sessions'] loop
    execute format('select count(*) from public.%I where user_id = %L', t, '00000000-0000-0000-0000-00000000000b') into n;
    if n <> 0 then raise exception 'FALHA: sobraram % linha(s) de B em %', n, t; end if;
  end loop;
  select count(*) into n from public.profiles where id = '00000000-0000-0000-0000-00000000000b';
  if n <> 0 then raise exception 'FALHA: sobrou o perfil de B'; end if;
  select count(*) into n from public.workout_session_exercises where session_id = '00000000-0000-0000-0000-0000000000f2';
  if n <> 0 then raise exception 'FALHA: sobraram exercícios da sessão de B'; end if;
  -- A continua intacto.
  select count(*) into n from public.weight_logs where user_id = '00000000-0000-0000-0000-00000000000a';
  if n <> 1 then raise exception 'FALHA: exclusão de B afetou A'; end if;
  raise notice 'EXCLUSAO OK';
end $$;

rollback;
