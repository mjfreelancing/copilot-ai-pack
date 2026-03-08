# Script Templates

Copy-ready script templates for consuming repositories.

## Available templates

- `sync-global-copilot-assets.ps1.template`
  - Project-local wrapper around the global sync script.
  - Resolves target repo automatically from script location.
  - Supports `-Packs`, `-AssetProfile`, `-AssetsRepoPath`, `-ProfilesPath`, `-TokenFile`, and `-DryRun`.

## Usage

1. Copy `sync-global-copilot-assets.ps1.template` into target repo as `.github/scripts/sync-global-copilot-assets.ps1`.
2. Optionally set a default assets repo path or pass `-AssetsRepoPath` from tasks.
3. Use task templates in `templates/tasks/` to run dry-run/apply sync flows.
