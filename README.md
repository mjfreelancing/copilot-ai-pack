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
  - `language-agnostic-core/`
  - `csharp-core/`
  - `typescript-core/`
  - `react-client/`
  - `aspnetcore-api/`
  - `aspnetcore-integration-tests/`
  - `dotnet-unit-tests/`
  - `postgres-efcore/`
  - `docker-compose/`
  - `prompts-testing/`
  - `environment-preflight/`
- `sync/` — tooling and profile config
  - `sync-copilot-assets.ps1` — sync script used to apply packs
  - `pack-profiles.json` — reusable named profile definitions
  - `README.md` — sync usage details
- `templates/tasks/` — copy-ready VS Code task templates and docs

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

## Related docs

- Sync details: `sync/README.md`
- Task templates: `templates/tasks/README.md`
