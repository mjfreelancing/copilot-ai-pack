# copilot-ai-pack

Reusable Copilot asset packs and sync tooling for quickly bootstrapping consistent AI-assisted workflows across repositories.

## What this repository contains

This repo is a centralized asset source for:

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
- `templates/tasks/` — copy-ready VS Code task templates and docs

## Pack root README policy

Pack directories under `packs/*/` should not contain root-level `README.md` files.

Reason:

- The sync script copies pack contents into target repositories preserving relative paths from each pack root.
- Root-level files with the same name (especially `README.md`) can collide across packs and overwrite content in the target repo.
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

## Typical workflow for consuming repos

1. Add a project-local wrapper script that calls `sync/sync-copilot-assets.ps1`.
2. Add VS Code tasks using templates in `templates/tasks/`.
3. Run dry-run tasks first, then apply.

## Current defaults

This repository uses strict behavior to reduce ambiguity and risk.

- **Token format is strict:** token replacement supports `{{TOKEN}}` placeholders only.
- **Collision handling is strict:** sync fails fast when selected packs map multiple files to the same destination path.
- **Pack docs are centralized:** `packs/*/README.md` files are intentionally not used to avoid sync collisions.

## Testing

### Prerequisites

- PowerShell 7+ (`pwsh`) recommended.
- Pester 5+ required for tests in this repo.

Note: Windows includes an inbox Pester 3.x for Windows PowerShell 5.1, but this repo should use modern Pester 5 in `pwsh`.

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
- Task templates: `templates/tasks/README.md`
