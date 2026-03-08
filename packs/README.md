# Packs

This folder contains modular Copilot asset packs that can be composed per repository using `sync/sync-copilot-assets.ps1`.

## Available packs

- `aspnetcore-api`
- `aspnetcore-integration-tests`
- `csharp-core`
- `docker-compose`
- `dotnet-unit-tests`
- `environment-preflight`
- `language-agnostic-core`
- `postgres-efcore`
- `prompts-testing`
- `react-client`
- `typescript-core`

## How to use

Use direct pack selection:

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -Packs csharp-core,dotnet-unit-tests -DryRun
```

Or use profile-based composition from `sync/pack-profiles.json`:

```powershell
./sync/sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -AssetProfile dotnet-csharp-tests -DryRun
```

Pack root folders intentionally do not include `README.md` files to avoid destination-path collisions during sync.

Each pack root contains `pack.manifest.json` used by sync file selection.

Manifest schema:

- `include` (required): array of glob patterns.
- `exclude` (optional): array of glob patterns.

## Manifest path resolution and glob patterns

Patterns in `pack.manifest.json` are resolved relative to the pack root folder.

Example: for `packs/csharp-core/pack.manifest.json`, pattern `.github/**` matches files under `packs/csharp-core/.github/...`.

### Pattern behavior

- Paths are matched relative to pack root, not repo root.
- `/` is the path separator in patterns.
- `*` matches any characters within a single path segment.
- `**` matches across folder boundaries (recursive).
- `?` matches a single character within a path segment.

### Examples

Root files only:

- `"*.md"` → markdown files in pack root only.
- `"pack.manifest.json"` → the manifest file itself.

All files under a folder:

- `".github/**"` → every file under `.github` recursively.
- `"docs/**"` → every file under `docs` recursively.

All files matching a pattern in any sub-folder:

- `"**/*.instructions.md"` → any `*.instructions.md` file anywhere in pack.
- `"**/*.prompt.md"` → any `*.prompt.md` file anywhere in pack.

Common include/exclude combinations:

- Include all `.github` assets except scripts:
  - `include`: `".github/**"`
  - `exclude`: `".github/scripts/**"`

- Include only markdown instructions and prompts:
  - `include`: `".github/instructions/**/*.md"`, `".github/prompts/**/*.md"`

- Exclude one specific file:
  - `exclude`: `".github/prompts/repo_tests.prompt.md"`

Example manifest:

```json
{
  "include": [".github/**"],
  "exclude": [".github/scripts/**"]
}
```

Use the root catalog in `README.md` for pack intent summaries, and inspect each pack’s `.github/...` assets for implementation details.
