# Packs

This folder contains modular Copilot asset packs that you can combine per repository.

## How to choose quickly

- Start with `language-agnostic-core`.
- Add one language pack (`csharp-core` or `typescript-core`).
- Add framework/runtime packs only if your repository uses them (`react-client`, `aspnetcore-api`, `postgres-efcore`, `docker-compose`).
- Add testing guidance (`dotnet-unit-tests`, `aspnetcore-integration-tests`, `prompts-testing`) when test work is in scope.
- Add `environment-preflight` if your team wants repeatable machine/tool checks.

If you want a pre-built combination, use a profile from `sync/pack-profiles.json`.

## Pack catalog

Each pack below shows when to use it, what files it copies, and what it does not cover.

### `language-agnostic-core`

Use when:

- You want baseline coding behavior that applies across stacks.

Copies:

- `.github/instructions/language-agnostic-core.instructions.md`

Not for / pitfalls:

- Does not provide language-specific syntax guidance.
- Combine with a language pack for best results.

### `csharp-core`

Use when:

- The repository has C#/.NET production code.

Copies:

- `.github/instructions/csharp.instructions.md`

Not for / pitfalls:

- Does not define API- or EF-specific conventions.
- Combine with `aspnetcore-api` and/or `postgres-efcore` when those concerns exist.

### `typescript-core`

Use when:

- The repository has TypeScript/JavaScript code and needs language-level guardrails.

Copies:

- `.github/instructions/typescript.instructions.md`

Not for / pitfalls:

- Does not include React-specific architecture and UX guidance.
- Combine with `react-client` for React apps.

### `react-client`

Use when:

- The repository includes a React frontend.

Copies:

- `.github/instructions/react-client.instructions.md`

Not for / pitfalls:

- Assumes TypeScript/client context and does not replace backend guidance.
- Pair with `typescript-core` for full language + framework coverage.

### `aspnetcore-api`

Use when:

- The repository exposes ASP.NET Core API endpoints.

Copies:

- `.github/instructions/aspnetcore-api.instructions.md`

Not for / pitfalls:

- Does not include integration-test project guidance by itself.
- Pair with `aspnetcore-integration-tests` and `dotnet-unit-tests` for testing workflows.

### `aspnetcore-integration-tests`

Use when:

- You run hosted API tests through real HTTP pipeline behavior.

Copies:

- `.github/instructions/aspnetcore.integration-tests.instructions.md`

Not for / pitfalls:

- Not intended for pure unit-test scenarios.
- Keep unit test conventions in `dotnet-unit-tests`.

### `dotnet-unit-tests`

Use when:

- You need deterministic .NET unit testing conventions.

Copies:

- `.github/instructions/dotnet.tests.instructions.md`

Not for / pitfalls:

- Does not define API host bootstrapping or DB-backed integration test behavior.
- Pair with `aspnetcore-integration-tests` for hosted/API boundary tests.

### `postgres-efcore`

Use when:

- The repository uses EF Core with PostgreSQL and migration-driven schema changes.

Copies:

- `.github/instructions/postgres-efcore.instructions.md`

Not for / pitfalls:

- Does not replace generic C# architecture guidance.
- Pair with `csharp-core` and `aspnetcore-api` in backend repositories.

### `docker-compose`

Use when:

- The repository includes Docker Compose lifecycle workflows.

Copies:

- `.github/instructions/docker.instructions.md`

Not for / pitfalls:

- Does not add compose files or service definitions.
- Focuses on workflow safety and validation patterns.

### `prompts-testing`

Use when:

- You want reusable prompt entry points for test authoring/execution tasks.

Copies:

- `.github/prompts/repo_tests.prompt.md`
- `.github/prompts/typescript_tests.prompt.md`
- `.github/prompts/dotnet_unit_test.prompt.md`
- `.github/prompts/dotnet_integration_test.prompt.md`

Not for / pitfalls:

- Prompts reference tokens like `{{SERVER_ROOT}}` and `{{CLIENT_ROOT}}`.
- Provide a token file during sync when using tokenized prompts.

### `environment-preflight`

Use when:

- You want standardized pre-session environment diagnostics.

Copies:

- `.github/skills/README.md`
- `.github/skills/environment-preflight/SKILL.md`
- `.github/scripts/README.md`
- `.github/scripts/agent-env-diagnostics.ps1`

Not for / pitfalls:

- This pack includes a script that can perform installs only in opt-in modes.
- Team policy should decide whether install-capable modes are allowed by default.

## Manifest requirements

Each pack root must include `pack.manifest.json`.

- `include` is required and must be a string array.
- `exclude` is optional and must be a string array when present.
- Sync fails if a selected pack is missing a manifest or has invalid schema.

Current pack manifests use:

```json
{
  "include": [".github/**"],
  "exclude": []
}
```

## Manifest path resolution and glob patterns

Patterns in `pack.manifest.json` are resolved relative to the pack root.

Example: for `packs/csharp-core/pack.manifest.json`, pattern `.github/**` matches `packs/csharp-core/.github/...`.

Pattern behavior:

- Paths are matched relative to pack root, not repository root.
- `/` is the path separator in patterns.
- `*` matches any characters within a single path segment.
- `**` matches across folder boundaries.
- `?` matches one character within a segment.

Examples:

- `"*.md"` matches markdown files in pack root only.
- `".github/**"` matches all files under `.github` recursively.
- `"**/*.instructions.md"` matches instruction files anywhere in pack.
- `"**/*.prompt.md"` matches prompt files anywhere in pack.

Common include/exclude combinations:

- Include all `.github` assets except scripts:
  - `include`: `".github/**"`
  - `exclude`: `".github/scripts/**"`
- Include only instructions and prompts:
  - `include`: `".github/instructions/**/*.md"`, `".github/prompts/**/*.md"`
- Exclude one file:
  - `exclude`: `".github/prompts/repo_tests.prompt.md"`
