# copilot-ai-pack

Reusable Copilot asset packs and sync tooling for quickly bootstrapping consistent AI-assisted workflows across repositories.

## What this repository contains

This repository is a centralized asset source for:

- language/framework-specific Copilot instructions and prompts
- test and preflight guidance packs
- reusable pack profiles for common project types
- sync automation to apply selected packs into another repository
- copy-ready VS Code task templates for non-CLI usage

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

## First-time setup in a consuming repository

Use this flow when you want to apply these assets to another repository with minimal PowerShell knowledge.

1. Copy wrapper script template into the target repository:

- from `templates/scripts/sync-global-copilot-assets.ps1.template`
- to `.github/scripts/sync-global-copilot-assets.ps1`

2. Copy one task template into target repository `.vscode/tasks.json`:

- use `templates/tasks/minimal.tasks.template.jsonc` for a simple default flow
- or use `templates/tasks/interactive.tasks.template.jsonc` for profile/path prompts

3. Run task `sync-global-copilot-assets-dryrun` first.
4. Review planned file writes and verify there are no collisions or path mistakes.
5. Run the apply task (`sync-global-copilot-assets`) after dry-run looks correct.

See detailed setup docs:

- `templates/scripts/README.md`
- `templates/tasks/README.md`
- `sync/README.md`

## Pack root README policy

Pack directories under `packs/*/` should not contain root-level `README.md` files.

Reason:

- The sync script copies pack contents into target repositories preserving relative paths from each pack root.
- Root-level files with the same name (especially `README.md`) can collide across packs and overwrite content in the target repository.
- Consolidating pack intent in this root README avoids duplicate documentation and reduces sync risk.

For pack details, use the assets under each pack’s `.github/...` structure and the pack catalog in this file.

## Quick start

### Dry run (recommended first)

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests -DryRun
```

### Apply selected packs

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests
```

### Apply using a profile

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -AssetProfile dotnet-csharp-tests
```

## Available profiles

Defined in `sync/pack-profiles.json`:

- `dotnet-csharp-tests`
- `react-typescript-client`
- `aspnetcore-api-postgres`
- `fullstack-react-aspnet-postgres`

### Which profile should I pick?

| If your repository is...                                    | Start with profile                | Why                                                                         |
| ----------------------------------------------------------- | --------------------------------- | --------------------------------------------------------------------------- |
| C#/.NET backend, service, or library                        | `dotnet-csharp-tests`             | Adds baseline + C# + .NET unit test guidance + testing prompts + preflight. |
| React + TypeScript frontend                                 | `react-typescript-client`         | Adds baseline + TypeScript + React + testing prompts + preflight.           |
| ASP.NET Core API with Postgres/EF                           | `aspnetcore-api-postgres`         | Adds API + integration/unit test + Postgres/EF guidance in one profile.     |
| Full-stack React + ASP.NET Core + Postgres + Docker workflow | `fullstack-react-aspnet-postgres` | Includes frontend, backend, DB, and Docker-oriented guidance together.      |

### Profile to packs map

| Profile | Included packs |
| --- | --- |
| `dotnet-csharp-tests` | `language-agnostic-core`, `csharp-core`, `dotnet-unit-tests`, `prompts-testing`, `environment-preflight` |
| `react-typescript-client` | `language-agnostic-core`, `typescript-core`, `react-client`, `prompts-testing`, `environment-preflight` |
| `aspnetcore-api-postgres` | `language-agnostic-core`, `csharp-core`, `aspnetcore-api`, `aspnetcore-integration-tests`, `dotnet-unit-tests`, `postgres-efcore`, `prompts-testing`, `environment-preflight` |
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

## Typical workflow for consuming repositories

1. Add a project-local wrapper script that calls `sync/sync-copilot-assets.ps1`.
2. Add VS Code tasks using templates in `templates/tasks/`.
3. Run dry-run tasks first, then apply.

## Current defaults

This repository uses strict behavior to reduce ambiguity and risk.

- **Token format is strict:** token replacement supports `{{TOKEN}}` placeholders only.
- **Collision handling is strict:** sync fails fast when selected packs map multiple files to the same destination path.
- **Manifest usage is strict:** each selected pack must define `pack.manifest.json` with valid include/exclude patterns.
- **Pack docs are centralized:** `packs/*/README.md` files are intentionally not used to avoid sync collisions.

## Testing

### Prerequisites

- PowerShell 7+ (`pwsh`) recommended.
- Pester 5+ required for tests in this repository.

Note: Windows includes an inbox Pester 3.x for Windows PowerShell 5.1, but this repository should use modern Pester 5 in `pwsh`.

### Install prerequisites

From repository root in `pwsh`:

```powershell
# Ensure NuGet provider is available
if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}

# Install Pester for current user
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber

# Verify highest available version
Get-Module -ListAvailable -Name Pester |
  Sort-Object Version -Descending |
  Select-Object -First 3 Name,Version,Path
```

### Run tests

Run all sync tests:

```powershell
./scripts/run-tests.ps1
```

Run a specific test file or folder:

```powershell
./scripts/run-tests.ps1 -Path ./sync/tests/sync-copilot-assets.Tests.ps1
```

### Validate test output

Expected success summary:

- `Tests Passed: <n>, Failed: 0`

If failures occur:

- Read the failing `It` case name and error message.
- Fix the script behavior or test expectation.
- Re-run the same test file first, then the full `./sync/tests` folder.

## Related docs

- Sync details: `sync/README.md`
- Script templates: `templates/scripts/README.md`
- Task templates: `templates/tasks/README.md`
