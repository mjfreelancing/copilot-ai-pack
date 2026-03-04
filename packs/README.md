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

See each pack subfolder README for its intent.
