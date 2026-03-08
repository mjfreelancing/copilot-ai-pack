# Script Templates

Copy-ready script templates for consuming repositories.

## Available templates

- `sync-global-copilot-assets.ps1.template`
  - Project-local wrapper around the global sync script.
  - Resolves target repository automatically from script location.
  - Supports `-Packs`, `-AssetProfile`, `-AssetsRepoPath`, `-ProfilesPath`, `-TokenFile`, and `-DryRun`.

## Usage

1. Copy `sync-global-copilot-assets.ps1.template` into the target repository as `.github/scripts/sync-global-copilot-assets.ps1`.
2. Open the copied file and set the default assets repository path if your team wants a fixed location.
3. Add task entries from `templates/tasks/` so developers run named tasks instead of raw PowerShell commands.
4. Run a dry-run task first, then run apply task.

## Why use the wrapper

- Keeps `-TargetRepo` resolution local to the consuming repository.
- Hides most sync parameters from day-to-day usage.
- Lets teams standardize one command surface in `.vscode/tasks.json`.

## Minimal manual command

If you need to test wrapper behavior directly from the target repository root:

```powershell
./.github/scripts/sync-global-copilot-assets.ps1 -DryRun -AssetProfile "dotnet-csharp-tests"
```
