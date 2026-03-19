# prompts-testing

## Purpose

Reusable prompts for planning, creating, and running tests across common stacks.

## When to use

- You want testing-focused prompts available in your repository.
- You need prompt starters for .NET and TypeScript testing tasks.

## What it provides

- `.github/prompts/repo_tests.prompt.md`
- `.github/prompts/typescript_tests.prompt.md`
- `.github/prompts/dotnet_unit_test.prompt.md`
- `.github/prompts/dotnet_integration_test.prompt.md`

## Best paired with

- `dotnet-unit-tests`
- `aspnetcore-integration-tests`
- `typescript-core`
- `react-client`

## Not intended for

- Replacing repository-specific test command decisions.

## Manual integration

Copy this pack's `.github` content into your target repository.

Prompts include example paths that can be adjusted to match your repository layout.
Prompts intentionally do not pin a model so teams can use their preferred Copilot model in each environment.
