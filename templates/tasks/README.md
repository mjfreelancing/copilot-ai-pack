# VS Code Task Templates

Copy-ready task snippets for consuming repositories that want a non-CLI workflow.

## What you get

- `minimal.tasks.template.jsonc`
  - Adds two tasks:
    - `sync-global-copilot-assets-dryrun`
    - `sync-global-copilot-assets`
  - Best for teams that want one default profile and inferred assets path.

- `interactive.tasks.template.jsonc`
  - Adds two tasks with VS Code prompts:
    - `sync-global-copilot-assets-dryrun-with-options`
    - `sync-global-copilot-assets-with-options`
  - Adds `inputs` for profile/path selection.
  - Best for teams that use multiple profiles or custom assets-repo locations.

- `backend-only.tasks.template.jsonc`
  - Adds two profile-pinned tasks:
    - `sync-global-copilot-assets-dryrun-backend-only`
    - `sync-global-copilot-assets-backend-only`
  - Uses profile `dotnet-csharp-tests` (C# + .NET unit tests + test prompts + preflight).
  - Best for API/service/library repos that do not need frontend/docker/postgres packs.

- `frontend-only.tasks.template.jsonc`
  - Adds two profile-pinned tasks:
    - `sync-global-copilot-assets-dryrun-frontend-only`
    - `sync-global-copilot-assets-frontend-only`
  - Uses profile `react-typescript-client` (TypeScript + React + testing prompts + preflight).
  - Best for frontend repos that do not need backend/postgres/docker packs.

- `api-postgres-only.tasks.template.jsonc`
  - Adds two profile-pinned tasks:
    - `sync-global-copilot-assets-dryrun-api-postgres-only`
    - `sync-global-copilot-assets-api-postgres-only`
  - Uses profile `aspnetcore-api-postgres` (C# + ASP.NET Core API + integration/unit tests + Postgres/EF + testing prompts + preflight).
  - Best for backend API repos with database concerns and no frontend pack requirements.

- `tests.tasks.template.jsonc`
  - Adds one task:
    - `run-tests`
  - Runs `./scripts/run-tests.ps1` from workspace root.
  - Best for repos that include a PowerShell test runner script.

## Prerequisite in target repo

Create a project-local wrapper script (for example `.github/scripts/sync-global-copilot-assets.ps1`).

Use this template from the assets repo:

- `templates/scripts/sync-global-copilot-assets.ps1.template`

The task templates intentionally call the local wrapper, not the global script directly.

If using `tests.tasks.template.jsonc`, ensure the target repo includes `./scripts/run-tests.ps1`.

## How to use

1. Open target repository `.vscode/tasks.json`.
2. Copy the selected `tasks` entries from one template file.
3. If using interactive template, also copy the `inputs` block.
4. Save and run via **Command Palette -> Tasks: Run Task**.

## Notes

- Templates are examples; adjust labels and defaults to your team terminology.
- Prefer running dry-run task first.
- Keep parameter name `-AssetProfile` (not `-Profile`).

## Parameter mapping quick reference

Use this section when updating task templates or wrapper script parameters.

| Task template value              | Wrapper parameter    | Final sync parameter | Purpose                                            |
| -------------------------------- | -------------------- | -------------------- | -------------------------------------------------- |
| `${input:copilotAssetsProfile}`  | `-AssetProfile`      | `-AssetProfile`      | Select a profile-defined pack set.                 |
| `${input:copilotAssetsRepoPath}` | `-AssetsRepoPath`    | _wrapper-only_       | Locate the assets repo where sync script lives.    |
| `-DryRun` in task command        | `-DryRun`            | `-DryRun`            | Preview selected files and targets without writes. |
| Wrapper default target path      | _derived in wrapper_ | `-TargetRepo`        | Set target repo to workspace root.                 |

Common task command examples:

- Dry run with profile prompt:
  - `./.github/scripts/sync-global-copilot-assets.ps1 -DryRun -AssetProfile "${input:copilotAssetsProfile}" -AssetsRepoPath "${input:copilotAssetsRepoPath}"`
- Apply with profile prompt:
  - `./.github/scripts/sync-global-copilot-assets.ps1 -AssetProfile "${input:copilotAssetsProfile}" -AssetsRepoPath "${input:copilotAssetsRepoPath}"`

For full wrapper-to-sync parameter flow, see [../../sync/README.md](../../sync/README.md).
