# VS Code Task Templates

Copy-ready task snippets for consuming repositories that want a non-CLI workflow.

## Pick the right template first

- Choose `minimal` if your team usually runs one profile.
- Choose `interactive` if developers need to pick profile/path at runtime.
- Choose one of the profile-pinned templates when repository type is stable (`backend-only`, `frontend-only`, `api-postgres-only`).
- Add `tests.tasks.template.jsonc` when the target repository includes `.\scripts\run-tests.ps1`.

## Pick the right profile quickly

Use these profile names when a task or wrapper asks for `-AssetProfile`:

| Use case                                                                                | Profile                           |
| --------------------------------------------------------------------------------------- | --------------------------------- |
| C#/.NET backend, service, or library repositories                                       | `dotnet-csharp-tests`             |
| React + TypeScript frontend repositories                                                | `react-typescript-client`         |
| ASP.NET Core API + Postgres/EF repositories                                             | `aspnetcore-api-postgres`         |
| Full-stack React + ASP.NET Core + Postgres repositories (with Docker workflow guidance) | `fullstack-react-aspnet-postgres` |

---

For full profile-to-pack composition details, see [../../README.md](../../README.md).

## What you get

| Template                                 | Tasks added                                                                                           | Profile used              | Best for                                                                               |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------- | -------------------------------------------------------------------------------------- |
| `minimal.tasks.template.jsonc`           | `sync-global-copilot-assets-dryrun`, `sync-global-copilot-assets`                                     | Wrapper default behavior  | Teams that want one default profile and inferred assets path.                          |
| `interactive.tasks.template.jsonc`       | `sync-global-copilot-assets-dryrun-with-options`, `sync-global-copilot-assets-with-options`           | User-selected via inputs  | Teams that use multiple profiles or custom assets-repository locations.                |
| `backend-only.tasks.template.jsonc`      | `sync-global-copilot-assets-dryrun-backend-only`, `sync-global-copilot-assets-backend-only`           | `dotnet-csharp-tests`     | API/service/library repositories that do not need frontend/docker/postgres packs.      |
| `frontend-only.tasks.template.jsonc`     | `sync-global-copilot-assets-dryrun-frontend-only`, `sync-global-copilot-assets-frontend-only`         | `react-typescript-client` | Frontend repositories that do not need backend/postgres/docker packs.                  |
| `api-postgres-only.tasks.template.jsonc` | `sync-global-copilot-assets-dryrun-api-postgres-only`, `sync-global-copilot-assets-api-postgres-only` | `aspnetcore-api-postgres` | Backend API repositories with database concerns and no frontend pack requirements.     |
| `tests.tasks.template.jsonc`             | `run-tests`                                                                                           | N/A                       | Repositories that include a PowerShell test runner script (`.\scripts\run-tests.ps1`). |

## Prerequisite in target repository

Create a project-local wrapper script (for example `.github/scripts/sync-global-copilot-assets.ps1`).

Use this template from the assets repository:

- `templates/scripts/sync-global-copilot-assets.ps1.template`

The task templates intentionally call the local wrapper, not the global script directly.

If using `tests.tasks.template.jsonc`, ensure the target repository includes `.\scripts\run-tests.ps1`.

## How to use

1. Open target repository `.vscode/tasks.json`.
2. Copy the selected `tasks` entries from one template file.
3. If using interactive template, also copy the `inputs` block.
4. Save and run via **Command Palette -> Tasks: Run Task**.
5. Run dry-run task first; apply only after planned writes look correct.

## Notes

- Templates are examples; adjust labels and defaults to your team terminology.
- Prefer running dry-run task first.
- Keep parameter name `-AssetProfile` (not `-Profile`).

## Parameter mapping quick reference

Use this section when updating task templates or wrapper script parameters.

| Task template value              | Wrapper parameter    | Final sync parameter | Purpose                                               |
| -------------------------------- | -------------------- | -------------------- | ----------------------------------------------------- |
| `${input:copilotAssetsProfile}`  | `-AssetProfile`      | `-AssetProfile`      | Select a profile-defined pack set.                    |
| `${input:copilotAssetsRepoPath}` | `-AssetsRepoPath`    | _wrapper-only_       | Locate the assets repository where sync script lives. |
| `-DryRun` in task command        | `-DryRun`            | `-DryRun`            | Preview selected files and targets without writes.    |
| Wrapper default target path      | _derived in wrapper_ | `-TargetRepo`        | Set target repository to workspace root.              |

Common task command examples:

- Dry run with profile prompt:
  - `.\.github\scripts\sync-global-copilot-assets.ps1 -DryRun -AssetProfile "${input:copilotAssetsProfile}" -AssetsRepoPath "${input:copilotAssetsRepoPath}"`
- Apply with profile prompt:
  - `.\.github\scripts\sync-global-copilot-assets.ps1 -AssetProfile "${input:copilotAssetsProfile}" -AssetsRepoPath "${input:copilotAssetsRepoPath}"`

For full wrapper-to-sync parameter flow, see [../../sync/README.md](../../sync/README.md).
