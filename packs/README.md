# Packs

This folder contains modular Copilot asset packs for manual adoption.

## Manual integration workflow

1. Pick the packs that match your stack.
2. Copy each selected pack's `.github` content into your target repository.
3. Adjust copied files to your repository conventions as needed.

## Manual adoption checklist

- Confirm which stack areas your repository has (language, framework, database, testing, tooling).
- Start with baseline + one language pack.
- Add framework/database/testing packs only when needed.
- Validate copied instruction and prompt paths against your repository structure.
- Commit pack changes in small, reviewable batches.

## How to choose quickly

- Start with `language-agnostic-core`.
- Add one language pack (`csharp-core` or `typescript-core`).
- Add framework/runtime packs only if your repository uses them (`react-client`, `aspnetcore-api`, `postgres-efcore`, `docker-compose`).
- Add testing guidance (`dotnet-unit-tests`, `aspnetcore-integration-tests`, `prompts-testing`) when test work is in scope.
- Add `agent-env-tools` if your team wants repeatable agent setup and readiness tools.

## Common combinations

| Use case                                | Suggested packs                                                                                                                   |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| C#/.NET service or library              | `language-agnostic-core`, `csharp-core`, `dotnet-unit-tests`                                                                      |
| ASP.NET Core API + Postgres             | `language-agnostic-core`, `csharp-core`, `aspnetcore-api`, `aspnetcore-integration-tests`, `dotnet-unit-tests`, `postgres-efcore` |
| React + TypeScript app                  | `language-agnostic-core`, `typescript-core`, `react-client`, `prompts-testing`                                                    |
| Any stack + agent setup/readiness tools | Add `agent-env-tools` to your selected packs                                                                                      |

## Pack catalog

### `language-agnostic-core`

Use when:

- You want baseline coding behavior that applies across stacks.

Provides:

- Cross-language instruction guidance.

Works well with:

- Any language/framework pack.

### `csharp-core`

Use when:

- The repository has C#/.NET production code.

Provides:

- C# language and architecture guidance.

Works well with:

- `aspnetcore-api`
- `postgres-efcore`
- `dotnet-unit-tests`

### `typescript-core`

Use when:

- The repository has TypeScript/JavaScript code and needs language-level guardrails.

Provides:

- TypeScript language and runtime guidance.

Works well with:

- `react-client`
- `prompts-testing`

### `react-client`

Use when:

- The repository includes a React frontend.

Provides:

- React architecture, state, and UI guidance.

Works well with:

- `typescript-core`
- `prompts-testing`

### `aspnetcore-api`

Use when:

- The repository exposes ASP.NET Core API endpoints.

Provides:

- API endpoint and contract guidance.

Note:

- When used with `csharp-core`, treat `csharp-core` as baseline C# guidance and `aspnetcore-api` as API-focused refinements for endpoint and contract work.

Works well with:

- `csharp-core`
- `aspnetcore-integration-tests`
- `dotnet-unit-tests`
- `postgres-efcore` (when DB-backed)

### `aspnetcore-integration-tests`

Use when:

- You run hosted API tests through real HTTP pipeline behavior.

Provides:

- ASP.NET Core integration testing guidance.

Works well with:

- `aspnetcore-api`
- `dotnet-unit-tests`

### `dotnet-unit-tests`

Use when:

- You need deterministic .NET unit testing conventions.

Provides:

- .NET unit testing guidance.

Works well with:

- `csharp-core`
- `aspnetcore-api`
- `aspnetcore-integration-tests`

### `postgres-efcore`

Use when:

- The repository uses EF Core with PostgreSQL and migration-driven schema changes.

Provides:

- PostgreSQL + EF Core modeling/query/migration guidance.

Works well with:

- `csharp-core`
- `aspnetcore-api`

### `docker-compose`

Use when:

- The repository includes Docker Compose lifecycle workflows.

Provides:

- Docker workflow safety and validation guidance.

Works well with:

- Any stack that includes local containerized workflows.

### `prompts-testing`

Use when:

- You want reusable prompt entry points for test authoring/execution tasks.

Provides:

- Test-focused prompt files for .NET and TypeScript workflows.

Note:

- Prompts include example paths that can be adjusted to match your repository layout.

Works well with:

- `dotnet-unit-tests`
- `aspnetcore-integration-tests`
- `typescript-core`
- `react-client`

### `agent-env-tools`

Use when:

- You want standardized pre-session environment diagnostics.

Provides:

- A reusable agent environment diagnostics skill and script.

Works well with:

- Any stack where agent environment consistency matters.

## Per-pack documentation

Each pack includes a local `README.md` with targeted usage guidance.

Maintainers should use [REVIEW-CHECKLIST.md](REVIEW-CHECKLIST.md) before merging pack changes.
