# copilot-ai-pack

Reusable Copilot asset packs and sync tooling for quickly bootstrapping consistent AI-assisted workflows across repositories.

## Purpose

This repository is the source of reusable Copilot assets that you apply to another repository.

It provides:

- modular packs of instructions/prompts/skills
- reusable profiles that bundle packs together
- a sync script that copies selected assets into a target repository
- wrapper and VS Code task templates for repeatable execution

## Core concepts

- **Pack**: one modular asset set (for example `csharp-core` or `react-client`).
- **Profile**: a named bundle of multiple packs (for example `aspnetcore-api-postgres`).
- **Sync**: the process of copying selected pack assets into a target repository.

You can select packs directly, or select one profile that expands to multiple packs.

## Choose your sync input

Use **one** of these selection models:

- **Profile-based selection**: choose one profile that maps to multiple packs.
- **Pack-based selection**: provide explicit pack names.

## Recommended first run (consuming repository flow)

Use this flow in the repository that should receive Copilot assets.

1. Copy `templates/scripts/sync-global-copilot-assets.ps1.template` into the target repository as `.github/scripts/sync-global-copilot-assets.ps1`.
2. Copy one task template into target repository `.vscode/tasks.json`:
   - use `templates/tasks/minimal.tasks.template.jsonc` for one default profile and fixed assets path
   - use `templates/tasks/interactive.tasks.template.jsonc` for runtime profile/path prompts

3. Run task `sync-global-copilot-assets-dryrun`.
4. Review planned file writes and verify there are no collisions or path mistakes.
5. Run task `sync-global-copilot-assets` to apply.

Detailed setup docs:

- `templates/scripts/README.md`
- `templates/tasks/README.md`
- `sync/README.md`

## Direct CLI usage (alternative)

Use this when running sync directly from this assets repository.

Dry run with explicit packs:

```powershell
.\sync\sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests -DryRun
```

Apply with explicit packs:

```powershell
.\sync\sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests
```

Apply with a profile:

```powershell
.\sync\sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -AssetProfile dotnet-csharp-tests
```

## End-to-end example (before/after)

Example scenario:

- Target repository: `C:\Work\orders-api`
- Selected profile: `aspnetcore-api-postgres`
- Commands (dry run first, then apply):

```powershell
# Dry Run
.\sync\sync-copilot-assets.ps1 -TargetRepo "C:\Work\orders-api" -AssetProfile aspnetcore-api-postgres -DryRun

# Apply
.\sync\sync-copilot-assets.ps1 -TargetRepo "C:\Work\orders-api" -AssetProfile aspnetcore-api-postgres
```

Before sync, target repository may not contain Copilot assets:

```text
orders-api/
  src/
  tests/
  README.md
```

After apply run (without `-DryRun`), target repository includes copied assets such as:

```text
orders-api/
  .github/
    instructions/
      language-agnostic-core.instructions.md
      csharp.instructions.md
      aspnetcore-api.instructions.md
      aspnetcore.integration-tests.instructions.md
      dotnet.tests.instructions.md
      postgres-efcore.instructions.md
    prompts/
      repo_tests.prompt.md
      dotnet_unit_test.prompt.md
      dotnet_integration_test.prompt.md
      typescript_tests.prompt.md
    scripts/
      README.md
      agent-env-diagnostics.ps1
    skills/
      README.md
      environment-preflight/
        SKILL.md
  src/
  tests/
  README.md
```

Notes:

- Exact files come from selected packs and each pack's `pack.manifest.json`.
- Existing non-Copilot project files are unchanged unless a destination-path collision is introduced (which fails sync).

## Available profiles

`sync/pack-profiles.json` defines the available profiles. Use `-AssetProfile` to apply one.

### Which profile should I pick?

| If your repository is...                                     | Start with profile                | Why                                                                         |
| ------------------------------------------------------------ | --------------------------------- | --------------------------------------------------------------------------- |
| C#/.NET backend, service, or library                         | `dotnet-csharp-tests`             | Adds baseline + C# + .NET unit test guidance + testing prompts + preflight. |
| React + TypeScript frontend                                  | `react-typescript-client`         | Adds baseline + TypeScript + React + testing prompts + preflight.           |
| ASP.NET Core API with Postgres/EF                            | `aspnetcore-api-postgres`         | Adds API + integration/unit test + Postgres/EF guidance in one profile.     |
| Full-stack React + ASP.NET Core + Postgres + Docker workflow | `fullstack-react-aspnet-postgres` | Includes frontend, backend, DB, and Docker-oriented guidance together.      |

### Profile to packs map

| Profile                           | Included packs                                                                                                                                                                                                                     |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `dotnet-csharp-tests`             | `language-agnostic-core`, `csharp-core`, `dotnet-unit-tests`, `prompts-testing`, `environment-preflight`                                                                                                                           |
| `react-typescript-client`         | `language-agnostic-core`, `typescript-core`, `react-client`, `prompts-testing`, `environment-preflight`                                                                                                                            |
| `aspnetcore-api-postgres`         | `language-agnostic-core`, `csharp-core`, `aspnetcore-api`, `aspnetcore-integration-tests`, `dotnet-unit-tests`, `postgres-efcore`, `prompts-testing`, `environment-preflight`                                                      |
| `fullstack-react-aspnet-postgres` | `language-agnostic-core`, `typescript-core`, `react-client`, `csharp-core`, `aspnetcore-api`, `aspnetcore-integration-tests`, `dotnet-unit-tests`, `docker-compose`, `postgres-efcore`, `prompts-testing`, `environment-preflight` |

## Pack catalog (what each pack adds)

Use `packs/README.md` as the detailed source of truth, including exact file paths, when-to-use guidance, and common pitfalls.

Quick orientation:

- `language-agnostic-core`: baseline cross-language coding rules.
- `csharp-core`: C# language and architecture conventions.
- `typescript-core`: TypeScript language and runtime behavior guidance.
- `react-client`: React architecture, state, and UX guidance.
- `aspnetcore-api`: API endpoint, contracts, and runtime rules.
- `aspnetcore-integration-tests`: hosted API integration testing guidance.
- `dotnet-unit-tests`: deterministic .NET unit testing conventions.
- `postgres-efcore`: EF Core and PostgreSQL modeling/query/migration rules.
- `docker-compose`: Docker lifecycle, safety, and validation workflow guidance.
- `prompts-testing`: reusable prompts for generating/running tests.
- `environment-preflight`: pre-session environment diagnostics skill and script.

## Repository structure

- `packs/` — modular asset packs to compose per project needs
  - `language-agnostic-core/` — cross-language baseline guidance
  - `csharp-core/` — core C# coding guidance and conventions
  - `typescript-core/` — core TypeScript guidance and conventions
  - `react-client/` — React client-side guidance and conventions
  - `aspnetcore-api/` — ASP.NET Core API guidance and conventions
  - `aspnetcore-integration-tests/` — ASP.NET Core integration testing guidance
  - `dotnet-unit-tests/` — .NET unit testing guidance and best practices
  - `postgres-efcore/` — PostgreSQL + EF Core guidance
  - `docker-compose/` — Docker Compose-related guidance
  - `prompts-testing/` — testing-focused prompt assets and guidance
  - `environment-preflight/` — environment/tooling preflight checks
- `sync/` — tooling and profile config
  - `sync-copilot-assets.ps1` — sync script used to apply packs
  - `pack-profiles.json` — reusable named profile definitions
  - `README.md` — sync usage details
- `templates/scripts/` — copy-ready wrapper script templates
- `templates/tasks/` — copy-ready VS Code task templates and docs

## Behavior guarantees

This repository uses strict behavior to reduce ambiguity and risk.

- **Token format is strict:** token replacement supports `{{TOKEN}}` placeholders only.
- **Collision handling is strict:** sync fails fast when selected packs map multiple files to the same destination path.
- **Manifest usage is strict:** each selected pack must define `pack.manifest.json` with valid include/exclude patterns.
- **Pack docs are centralized:** `packs/*/README.md` files are intentionally not used to avoid sync collisions.

## Common failure scenarios

### Unknown profile name

Symptoms:

- terminating validation error indicating the specified `-AssetProfile` is not found
- output lists available profile names from `sync/pack-profiles.json`

Fix:

- confirm spelling/casing of `-AssetProfile`
- open `sync/pack-profiles.json` and choose a valid profile
- re-run with `-DryRun` first

### Destination path collision across selected packs

Symptoms:

- terminating collision error listing the conflicting destination path(s)
- no files are written

Fix:

- reduce or change selected packs/profile
- inspect included files in pack manifests to identify overlap
- re-run `-DryRun` until plan is collision-free, then apply

### Missing or invalid `pack.manifest.json`

Symptoms:

- terminating validation error indicating missing manifest or invalid schema
- often references required `include` array and optional `exclude` array format

Fix:

- ensure each selected pack has `pack.manifest.json` at pack root
- ensure `include` is present and both `include`/`exclude` are arrays when provided
- re-run with `-DryRun` after correcting manifest

## Pack root README policy

Pack directories under `packs/*/` should not contain root-level `README.md` files.

Reason:

- The sync script copies pack contents into target repositories preserving relative paths from each pack root.
- Root-level files with the same name (especially `README.md`) can collide across packs and overwrite content in the target repository.
- Consolidating pack intent in this root README avoids duplicate documentation and reduces sync risk.

## Repository self-tests

These tests validate the sync tooling and behavior in this `copilot-ai-pack` repository itself (not tests for a consuming project).

### Prerequisites

- PowerShell 7+ (`pwsh`) recommended.
- Pester 5+ required for tests in this repository.

Note: Windows includes an inbox Pester 3.x for Windows PowerShell 5.1, but this repository should use modern Pester 5 in `pwsh`.

### Ensure prerequisites (recommended)

From repository root in `pwsh`:

```powershell
.\scripts\ensure-test-prereqs.ps1
```

This command checks prerequisites and installs only what is missing. If everything is already available, it logs that no installation is needed.

If PSGallery trust prompts block installation in non-interactive environments:

From repository root in `pwsh`:

```powershell
.\scripts\ensure-test-prereqs.ps1 -TrustPSGallery
```

### Run tests

Run all repository sync tests:

```powershell
.\scripts\run-tests.ps1
```

Run a specific test file or folder:

```powershell
.\scripts\run-tests.ps1 -Path .\sync\tests\sync-copilot-assets.Tests.ps1
```

### Validate test output

Expected success summary:

- `Tests Passed: <n>, Failed: 0`

If failures occur:

- Read the failing `It` case name and error message.
- Fix the script behavior or test expectation.
- Re-run the same test file first, then the full `.\sync\tests` folder.

## Related docs

- Sync details: `sync/README.md`
- Script templates: `templates/scripts/README.md`
- Task templates: `templates/tasks/README.md`
