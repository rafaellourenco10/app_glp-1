<div align="center">

<img src="assets/images/logo_mark.png" alt="Companheiro GLP-1" width="76">

# Companheiro GLP-1

**Diário de acompanhamento para quem usa canetas GLP-1**<br>
semaglutida, tirzepatida e afins: lembrete da aplicação, proteína, sintomas, peso e treinos de força, num só lugar.

[![Flutter](https://img.shields.io/badge/Flutter-Dart%203-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Postgres%20%2B%20RLS-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Riverpod](https://img.shields.io/badge/estado-Riverpod%203-0f766e)](https://riverpod.dev)
[![Plataformas](https://img.shields.io/badge/plataformas-Android%20%7C%20iOS-005c55)](#)
[![Idioma](https://img.shields.io/badge/idioma-pt--BR-913200)](#)

</div>

> [!IMPORTANT]
> Este app é um **diário de acompanhamento** e não substitui orientação de médico ou nutricionista.
> Ele **nunca** sugere, calcula ou ajusta dose. A dose é texto livre digitado pelo usuário, e o lembrete segue só o dia e a hora escolhidos.

---

## Sumário

- [Telas](#telas)
- [Funcionalidades](#funcionalidades)
- [Stack](#stack)
- [Começando rápido (modo demonstração)](#começando-rápido-modo-demonstração)
- [Configurando o Supabase](#configurando-o-supabase)
- [Notificação semanal da dose](#notificação-semanal-da-dose)
- [Privacidade e isolamento (RLS)](#privacidade-e-isolamento-rls)
- [Testes e qualidade](#testes-e-qualidade)
- [Estrutura do projeto](#estrutura-do-projeto)
- [Decisões do MVP](#decisões-do-mvp)

## Telas

<table>
  <tr>
    <td align="center"><img src="docs/screens/onboarding.png" width="190"><br><sub><b>Boas-vindas</b></sub></td>
    <td align="center"><img src="docs/screens/hoje.png" width="190"><br><sub><b>Hoje</b></sub></td>
    <td align="center"><img src="docs/screens/doses.png" width="190"><br><sub><b>Doses</b></sub></td>
    <td align="center"><img src="docs/screens/proteina.png" width="190"><br><sub><b>Proteína</b></sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screens/sintomas.png" width="190"><br><sub><b>Sintomas</b></sub></td>
    <td align="center"><img src="docs/screens/peso.png" width="190"><br><sub><b>Peso</b></sub></td>
    <td align="center"><img src="docs/screens/treinos.png" width="190"><br><sub><b>Treinos</b></sub></td>
    <td align="center"><img src="docs/screens/sessao.png" width="190"><br><sub><b>Sessão de treino</b></sub></td>
  </tr>
</table>

O visual segue o design system **Serene Wellness & Metabolic Care** ([telas/serene_wellness_metabolic_care/DESIGN.md](telas/serene_wellness_metabolic_care/DESIGN.md)), com as telas de referência em [telas/](telas/).

## Funcionalidades

| | Módulo | O que faz |
|---|---|---|
| 🧭 | **Onboarding** | Consentimento LGPD, dados básicos, medicação e rotina, meta diária de proteína |
| 🏠 | **Hoje** | Próxima aplicação, progresso de proteína com os últimos 7 dias, atalhos e treino do dia |
| 💉 | **Doses** | Registro das aplicações e lembrete semanal agendado no sistema (funciona com o app fechado) |
| 🥚 | **Proteína** | Registro por alimento (82 itens, base TACO) com soma diária contra a meta |
| 🩺 | **Sintomas** | Registro de intensidade e histórico |
| ⚖️ | **Peso** | Evolução em gráfico e registro |
| 🏋️ | **Treinos** | Modelos de força para preservar massa magra e sessão ativa com cronômetro e séries |
| ⚙️ | **Perfil** | Tema claro/escuro, exportar dados (JSON) e excluir conta |

## Stack

| Camada | Tecnologia |
|---|---|
| App | Flutter (Dart 3), Material 3, fonte Manrope |
| Estado e rotas | `flutter_riverpod` · `go_router` |
| Backend | `supabase_flutter` (Auth, Postgres com RLS, RPCs) |
| Notificações | `flutter_local_notifications` · `timezone` · `flutter_timezone` |
| Gráficos | `fl_chart` |
| Idioma | `gen-l10n` (pt-BR) · `intl` |

## Começando rápido (modo demonstração)

Dá para ver o app sem configurar nada:

```bash
flutter pub get
flutter run
```

Sem `.env` (ou com a configuração **Demo (sem Supabase)**, que é a padrão do **F5** no VS Code), o app abre direto, sem login e sem Supabase.
Os dados ficam só em memória e somem ao fechar o app (ver [lib/demo.dart](lib/demo.dart)). O lembrete local de dose funciona de verdade nesse modo.

## Configurando o Supabase

<details open>
<summary><b>1. Criar o projeto</b></summary>

1. Crie um projeto em <https://supabase.com/dashboard>.
2. Em **Project Settings → API**, copie a **Project URL** e a **anon / publishable key**.

</details>

<details open>
<summary><b>2. Rodar migrations e seed</b></summary>

Com a [Supabase CLI](https://supabase.com/docs/guides/cli):

```bash
supabase login
supabase link --project-ref SEU_PROJECT_REF
supabase db push --include-seed   # aplica supabase/migrations/* e supabase/seed.sql
```

Sem a CLI, cole no **SQL Editor** e execute, nesta ordem:
1. [`supabase/migrations/20261006000001_init.sql`](supabase/migrations/20261006000001_init.sql): tabelas, RLS, índices e as RPCs `delete_my_account` / `export_my_data`
2. [`supabase/seed.sql`](supabase/seed.sql): 82 alimentos e 4 modelos de treino (rode uma única vez)

</details>

<details open>
<summary><b>3. Auth (e-mail, Google e Apple)</b></summary>

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

Apple e Google usam o fluxo OAuth do Supabase no navegador e voltam ao app pelo deep link acima, já configurado em
`android/app/src/main/AndroidManifest.xml` e `ios/Runner/Info.plist`. Não há SDK nativo extra.

</details>

<details open>
<summary><b>4. Configurar o <code>.env</code> e rodar</b></summary>

```bash
cp .env.example .env    # preencha SUPABASE_URL e SUPABASE_ANON_KEY
flutter pub get
flutter run --dart-define-from-file=.env
```

No VS Code, escolha a configuração **Supabase (.env)** e aperte **F5**.

As chaves são lidas em tempo de compilação (`String.fromEnvironment`). O `.env` está no `.gitignore`.

</details>

## Notificação semanal da dose

O lembrete é agendado no sistema operacional (`zonedSchedule` com `DateTimeComponents.dayOfWeekAndTime`), por isso continua valendo com o
app fechado. No Android, um *boot receiver* reagenda o lembrete depois que o aparelho reinicia, e o app também reagenda a cada abertura.

**Como testar:**
1. Abra **Doses** (toque no card "Próxima aplicação" na Home, ou em Perfil → Lembrete da aplicação).
2. Escolha o dia de hoje e um horário **2 minutos à frente**, depois toque em **Salvar**. Aceite as permissões de notificação e, no Android 14 ou superior, a de *Alarmes e lembretes*.
3. Feche o app (pode removê-lo da lista de recentes) e espere: a notificação toca no horário.
4. Para testar a persistência, reinicie o app ou o aparelho: o agendamento continua, e a próxima ocorrência é na mesma hora da semana seguinte.

> [!NOTE]
> Sem a permissão de alarme exato, o Android usa um agendamento inexato, que pode atrasar alguns minutos.

## Privacidade e isolamento (RLS)

Cada tabela tem Row Level Security: cada usuário só enxerga e altera os próprios dados.
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

<details>
<summary>Rodar localmente com Docker, sem projeto na nuvem</summary>

```bash
docker run -d --name glp1db -e POSTGRES_PASSWORD=postgres supabase/postgres:17.6.1.011
docker exec -i glp1db psql -U postgres -h localhost -v ON_ERROR_STOP=1 < supabase/migrations/20261006000001_init.sql
docker exec -i glp1db psql -U postgres -h localhost -v ON_ERROR_STOP=1 < supabase/tests/rls_test.sql
```

</details>

## Testes e qualidade

```bash
flutter analyze   # sem issues
flutter test      # onboarding, registrar dose, registrar proteína (soma do dia), modo demo + lógica pura
```

Para gerar os prints das telas (saída em `build/screens/`):

```bash
flutter test test_screens/screens_test.dart
```

## Estrutura do projeto

```
lib/
├── main.dart · app.dart       # bootstrap, rotas (go_router) e tema
├── demo.dart                  # modo demonstração: repositórios em memória
├── core/
│   ├── supabase/              # cliente e sessão
│   ├── notifications/         # lembrete semanal da dose
│   ├── theme/                 # tokens do design system + widgets
│   └── l10n/                  # app_pt.arb e formatação
└── features/                  # cada uma com *_repository.dart + telas
    ├── auth · onboarding · home · doses · protein
    └── symptoms · weight · workouts · settings
supabase/
├── migrations/                # schema, RLS, índices e RPCs
├── seed.sql                   # alimentos e modelos de treino
└── tests/rls_test.sql         # prova de isolamento e exclusão
telas/                         # telas de referência (Stitch) e DESIGN.md
test/ · test_screens/          # testes e geração de prints
```

## Decisões do MVP

- O consentimento LGPD e o disclaimer são aceitos na 1ª etapa do onboarding (obrigatórios). A data do aceite fica em `profiles.consented_at`.
- **Excluir conta:** a RPC `delete_my_account()` (security definer) remove o usuário de `auth.users`, e o `ON DELETE CASCADE` apaga todos os dados.
- **Exportar dados:** a RPC `export_my_data()` gera o JSON, que é copiado para a área de transferência.
- O tema (sistema/claro/escuro) fica salvo no `user_metadata` da conta.
- A proteína dos alimentos é aproximada (Tabela TACO / rótulos usuais).
- Não há modo offline: só cache em memória (Riverpod) e mensagem de erro amigável com "Tentar novamente".

---

<div align="center">
<sub>Feito com Flutter e Supabase · Não substitui orientação profissional de saúde.</sub>
</div>
