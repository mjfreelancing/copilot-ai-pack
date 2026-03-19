# aspnetcore-integration-tests

## Purpose

Guidance for ASP.NET Core hosted integration tests that exercise real HTTP behavior.

## When to use

- You test API behavior end-to-end through the host pipeline.
- You want clear boundaries between integration and unit tests.

## What it provides

- `.github/instructions/aspnetcore.integration-tests.instructions.md`

## Best paired with

- `aspnetcore-api`
- `dotnet-unit-tests`

## Not intended for

- Pure in-process unit tests without host bootstrapping.

## Manual integration

Copy this pack's `.github` content into your target repository.
