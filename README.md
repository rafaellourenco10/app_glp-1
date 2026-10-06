# Companheiro GLP-1

Diário de acompanhamento para quem usa canetas GLP-1 (semaglutida, tirzepatida etc.): lembrete semanal da aplicação, proteína, sintomas, peso e treinos de força.

> Este app é um diário de acompanhamento e não substitui orientação de médico ou nutricionista.
> Ele **nunca** sugere, calcula ou ajusta dose. A dose é texto livre digitado pelo usuário e o lembrete segue só o dia e a hora escolhidos.

**Stack:** Flutter (Dart 3) · Riverpod · go_router · supabase_flutter · flutter_local_notifications + timezone · fl_chart · gen-l10n (pt-BR).
O visual segue as telas e o `DESIGN.md` em [telas/](telas/).

---

## 1. Supabase

### 1.1 Criar o projeto
1. Crie um projeto em <https://supabase.com/dashboard>.
2. Em **Project Settings → API**, copie a **Project URL** e a **anon / publishable key**.

### 1.2 Rodar migrations e seed

Com a [Supabase CLI](https://supabase.com/docs/guides/cli):

```bash
supabase login
supabase link --project-ref SEU_PROJECT_REF
supabase db push --include-seed   # aplica supabase/migrations/* e supabase/seed.sql
```

Sem a CLI, cole no **SQL Editor** e execute, nesta ordem:
1. `supabase/migrations/20261006000001_init.sql` (tabelas, RLS, índices e as RPCs `delete_my_account` / `export_my_data`)
2. `supabase/seed.sql` (82 alimentos e 4 modelos de treino; rode uma única vez)

### 1.3 Auth
Em **Authentication → URL Configuration → Redirect URLs**, adicione:

```
companheiroglp1://login-callback
```

- **E-mail (magic link):** já vem habilitado em *Authentication → Providers → Email*.
- **Google:** no Google Cloud Console, crie um *OAuth client ID* do tipo **Web application** com o redirect URI
  `https://SEU_PROJECT_REF.supabase.co/auth/v1/callback`. Cole o Client ID e o Secret em *Authentication → Providers → Google*.
- **Apple:** no Apple Developer, crie um **Services ID** (com *Sign in with Apple* e o Return URL
  `https://SEU_PROJECT_REF.supabase.co/auth/v1/callback`) e uma **Key** com Sign in with Apple. Em *Authentication → Providers → Apple*,
  informe o Services ID, o Team ID, o Key ID e o conteúdo do `.p8`.

Apple e Google usam o fluxo OAuth do Supabase no navegador e voltam ao app pelo deep link acima. Ele já está configurado em
`android/app/src/main/AndroidManifest.xml` e `ios/Runner/Info.plist`, então não há SDK nativo extra.

## 2. Configurar o `.env`

```bash
cp .env.example .env    # preencha SUPABASE_URL e SUPABASE_ANON_KEY
flutter pub get
flutter run --dart-define-from-file=.env
```

No VS Code, basta apertar **F5**: o `.vscode/launch.json` já passa o `.env`. Sem o `.env`, o app abre numa tela avisando que a configuração está ausente.

As chaves são lidas em tempo de compilação (`String.fromEnvironment`). O `.env` está no `.gitignore`.

## 3. Notificação semanal da dose

O lembrete é agendado no sistema operacional (`zonedSchedule` com `DateTimeComponents.dayOfWeekAndTime`). Por isso continua valendo com o
app fechado. No Android, um *boot receiver* reagenda o lembrete depois que o aparelho reinicia, e o app também reagenda a cada abertura.

**Como testar:**
1. Abra **Doses** (toque no card "Próxima aplicação" na Home, ou em Perfil → Lembrete da aplicação).
2. Escolha o dia de hoje e um horário **2 minutos à frente**, depois toque em **Salvar**. Aceite as permissões de notificação e, no Android 14 ou superior, a de *Alarmes e lembretes*.
3. Feche o app (pode removê-lo da lista de recentes) e espere: a notificação toca no horário.
4. Para testar a persistência, reinicie o app ou o aparelho: o agendamento continua, e a próxima ocorrência é na mesma hora da semana seguinte.

Sem a permissão de alarme exato, o Android usa um agendamento inexato, que pode atrasar alguns minutos.

## 4. Prova de isolamento entre usuários (RLS) e de exclusão de conta

[supabase/tests/rls_test.sql](supabase/tests/rls_test.sql) cria os usuários A e B, insere dados de B e, autenticado como A, verifica que A:
- não **lê** nenhuma linha de B em nenhuma tabela;
- não **altera** nem **apaga** linhas de B;
- não **insere** em nome de B, nem em `foods` ou nos catálogos;
- consegue gravar os próprios dados.

Em seguida, B chama `delete_my_account()` e o script confirma que o usuário e **todas** as linhas dele sumiram (cascade), sem afetar A.
Tudo roda dentro de uma transação com `ROLLBACK`.

```bash
psql "postgresql://postgres:SENHA@db.SEU_PROJECT_REF.supabase.co:5432/postgres" -f supabase/tests/rls_test.sql
# ou cole o arquivo no SQL Editor
```

Resultado esperado: `NOTICE: RLS OK` e `NOTICE: EXCLUSAO OK`. Qualquer falha aborta com `FALHA: ...`.

Para rodar localmente sem projeto na nuvem (requer Docker):

```bash
docker run -d --name glp1db -e POSTGRES_PASSWORD=postgres supabase/postgres:17.6.1.011
docker exec -i glp1db psql -U postgres -h localhost -v ON_ERROR_STOP=1 < supabase/migrations/20261006000001_init.sql
docker exec -i glp1db psql -U postgres -h localhost -v ON_ERROR_STOP=1 < supabase/tests/rls_test.sql
```

## 5. Qualidade

```bash
flutter analyze   # sem issues
flutter test      # onboarding, registrar dose, registrar proteína (soma do dia) + lógica pura
```

## Estrutura

```
lib/
  core/        supabase (cliente, sessão) · notifications · theme (tokens + widgets) · l10n (app_pt.arb, formatação)
  features/    auth · onboarding · home · doses · protein · symptoms · weight · workouts · settings
               (cada uma com um *_repository.dart que fala direto com o Supabase e as telas)
supabase/      migrations/ · seed.sql · tests/rls_test.sql
```

## Decisões do MVP
- O consentimento LGPD e o disclaimer são aceitos na 1ª etapa do onboarding (obrigatórios). A data do aceite fica em `profiles.consented_at`.
- Excluir conta: a RPC `delete_my_account()` (security definer) remove o usuário de `auth.users`, e o `ON DELETE CASCADE` apaga todos os dados.
- Exportar dados: a RPC `export_my_data()` gera o JSON, que é copiado para a área de transferência.
- O tema (sistema/claro/escuro) fica salvo no `user_metadata` da conta.
- A proteína dos alimentos é aproximada (Tabela TACO / rótulos usuais).
- Não há modo offline: só cache em memória (Riverpod) e mensagem de erro amigável com "Tentar novamente".
