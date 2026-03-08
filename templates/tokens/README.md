# Tokens Template

This folder contains example token files used with sync token replacement.

## File

- `default.tokens.example.json` — sample key/value map where keys map to `{{TOKEN}}` placeholders.

## Usage

Pass a token file to the sync script:

```powershell
.\sync\sync-copilot-assets.ps1 -TargetRepo "C:\Path\To\Repo" -AssetProfile dotnet-csharp-tests -TokenFile ".\templates\tokens\default.tokens.example.json"
```
