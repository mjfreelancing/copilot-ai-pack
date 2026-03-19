# aspnetcore-api

## Purpose

ASP.NET Core API guidance for endpoint design, contracts, and runtime behavior.

## When to use

- Your repository exposes ASP.NET Core APIs.
- You want consistent API structure and implementation practices.

## What it provides

- `.github/instructions/aspnetcore-api.instructions.md`

Note:

- When combined with `csharp-core`, treat `csharp-core` as baseline C# guidance and this pack as API-specific refinements.

## Best paired with

- `csharp-core`
- `aspnetcore-integration-tests`
- `dotnet-unit-tests`
- `postgres-efcore` when database-backed

## Not intended for

- Hosted integration testing detail (use `aspnetcore-integration-tests`).
- Unit-testing conventions (use `dotnet-unit-tests`).

## Manual integration

Copy this pack's `.github` content into your target repository.
