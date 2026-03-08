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

## Pack manifests

Each selected pack must define `pack.manifest.json` at pack root.

- `include`: required array of glob patterns.
- `exclude`: optional array of glob patterns.
- Missing manifest or invalid manifest schema fails sync.

See `packs/README.md` for detailed path-resolution rules and glob examples.

## Collision safety

The sync script performs destination-path collision detection before writing files.

- If two or more selected pack files map to the same target path, sync fails fast.
- No files are written when a collision is detected.
- Dry-run and apply use the same planning logic.

## Input validation

- If no packs are selected (directly or via profile), sync fails with a terminating error.
- The error lists available pack names and available profile names.

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
- [../templates/tasks/tests.tasks.template.jsonc](../templates/tasks/tests.tasks.template.jsonc)
- [../templates/tasks/README.md](../templates/tasks/README.md)

Wrapper script template is provided in:

- [../templates/scripts/sync-global-copilot-assets.ps1.template](../templates/scripts/sync-global-copilot-assets.ps1.template)

## Parameter compatibility matrix

This matrix shows how values flow from task templates to wrapper script parameters and then into the sync script.

| Source                                                 | Parameter / Input                | Maps to                                        | Notes                                                                         |
| ------------------------------------------------------ | -------------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------- |
| Task template (`interactive`)                          | `${input:copilotAssetsProfile}`  | Wrapper `-AssetProfile` → Sync `-AssetProfile` | Selects a named profile from `pack-profiles.json`.                            |
| Task template (`interactive`)                          | `${input:copilotAssetsRepoPath}` | Wrapper `-AssetsRepoPath`                      | Wrapper resolves sync script location from this path.                         |
| Task template (`minimal`)                              | No explicit profile input        | Wrapper default behavior                       | Wrapper chooses profile/default behavior configured in consuming repo script. |
| Task templates (`backend/frontend/api-postgres`)       | Hardcoded profile in command     | Wrapper `-AssetProfile` → Sync `-AssetProfile` | Profile is pinned in the task command.                                        |
| Wrapper                                                | `-Packs`                         | Sync `-Packs`                                  | Explicit pack names; merged with profile packs and de-duplicated.             |
| Wrapper                                                | `-AssetProfile`                  | Sync `-AssetProfile`                           | Profile-based pack selection.                                                 |
| Wrapper                                                | `-ProfilesPath`                  | Sync `-ProfilesPath`                           | Optional override path for profile JSON.                                      |
| Wrapper                                                | `-TokenFile`                     | Sync `-TokenFile`                              | Enables `{{TOKEN}}` replacement for supported text files.                     |
| Wrapper                                                | `-DryRun`                        | Sync `-DryRun`                                 | Generates plan output, writes no files.                                       |
| Wrapper (internal)                                     | Derived target repo path         | Sync `-TargetRepo`                             | Usually wrapper repo root (e.g., path resolved from script location).         |

### Required vs optional parameters

Sync script:

- **Required:** `-TargetRepo`
- **Required selection:** at least one of `-Packs` and/or `-AssetProfile`
- **Optional:** `-ProfilesPath`, `-TokenFile`, `-DryRun`

Wrapper template:

- **Optional user inputs:** `-Packs`, `-AssetProfile`, `-AssetsRepoPath`, `-ProfilesPath`, `-TokenFile`, `-DryRun`
- **Always resolved by wrapper:** `-TargetRepo`

### Example mappings

Interactive task dry-run:

1. User picks `aspnetcore-api-postgres` in task prompt.
2. Task calls wrapper with `-AssetProfile "aspnetcore-api-postgres" -DryRun`.
3. Wrapper calls sync script with `-TargetRepo <workspaceRoot> -AssetProfile aspnetcore-api-postgres -DryRun`.

Explicit packs apply run:

1. Wrapper receives `-Packs @('csharp-core','dotnet-unit-tests')`.
2. Wrapper calls sync script with same pack list and resolved target repo.
3. Sync validates pack manifests, plans copy set, checks collisions, then writes files.

Profile-pinned template run:

1. Task command includes fixed profile value (for example `-AssetProfile "dotnet-csharp-tests"`).
2. Wrapper forwards `-AssetProfile` to sync script.
3. Sync resolves profile pack list from `pack-profiles.json` and applies manifest-based sync.
