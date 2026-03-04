# Sync

## Files

- `sync-copilot-assets.ps1`: applies selected pack(s) into a target repo.
- `pack-profiles.json`: reusable pack combinations.

## Typical usage

Dry run:

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests -DryRun
```

Apply:

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests
```

Apply with profile:

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -AssetProfile dotnet-csharp-tests
```

Token replacement can be enabled via `-TokenFile` (JSON key-value pairs where keys map to `{{TOKEN}}` placeholders).

## Non-CLI usage model

This repository is designed to be consumed from project-local wrappers/tasks.

Recommended in each consuming repo:

1. Add a project-local wrapper script that calls this sync script.
2. Add VS Code tasks for dry-run and apply.
3. Let developers run updates via `Tasks: Run Task`.

Suggested task labels in consuming repos:

- `sync-global-copilot-assets-dryrun`
- `sync-global-copilot-assets`
- optional interactive variants with profile/path prompts.

Copy-ready task snippets are provided in:

- [../templates/tasks/minimal.tasks.template.jsonc](../templates/tasks/minimal.tasks.template.jsonc)
- [../templates/tasks/interactive.tasks.template.jsonc](../templates/tasks/interactive.tasks.template.jsonc)
- [../templates/tasks/backend-only.tasks.template.jsonc](../templates/tasks/backend-only.tasks.template.jsonc)
- [../templates/tasks/frontend-only.tasks.template.jsonc](../templates/tasks/frontend-only.tasks.template.jsonc)
- [../templates/tasks/api-postgres-only.tasks.template.jsonc](../templates/tasks/api-postgres-only.tasks.template.jsonc)
- [../templates/tasks/README.md](../templates/tasks/README.md)
