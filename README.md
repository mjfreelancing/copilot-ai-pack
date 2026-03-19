# copilot-ai-pack

Reusable Copilot asset packs for teams that want a simple, manual copy-and-adapt workflow.

## Purpose

This repository provides modular Copilot assets that you can copy into your own repository and customize locally.

What this repository offers:

- instruction packs for language/framework behavior
- testing prompts for common workflows
- an optional agent environment diagnostics pack

What this repository intentionally does not include:

- centralized sync orchestration
- profile combinator logic
- token file replacement pipelines

The operating model is intentionally straightforward: pick the packs you need, copy `.github` content, and adapt to your repository.

## Quick start

1. Open `packs/README.md` and pick packs for your stack.
2. In your repository, copy `.github` content from each selected pack.
3. Keep the copied files that fit your workflow; edit as needed.
4. Commit changes in your repository.

## Recommended starter combinations

| Repository type                              | Suggested packs                                                                                                                                                                         |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| .NET backend/service                         | `language-agnostic-core`, `csharp-core`, `dotnet-unit-tests`                                                                                                                            |
| ASP.NET Core API + Postgres                  | `language-agnostic-core`, `csharp-core`, `aspnetcore-api`, `aspnetcore-integration-tests`, `dotnet-unit-tests`, `postgres-efcore`                                                       |
| React + TypeScript client                    | `language-agnostic-core`, `typescript-core`, `react-client`, `prompts-testing`                                                                                                          |
| Full stack (React + ASP.NET Core + Postgres) | `language-agnostic-core`, `typescript-core`, `react-client`, `csharp-core`, `aspnetcore-api`, `aspnetcore-integration-tests`, `dotnet-unit-tests`, `postgres-efcore`, `prompts-testing` |
| Any repo needing environment checks          | Add `agent-env-tools`                                                                                                                                                                   |

## What you copy

Each pack stores assets under `.github/`.

Common asset types:

- `.github/instructions/*.instructions.md`
- `.github/prompts/*.prompt.md`
- `.github/skills/**` and `.github/scripts/**` (only in specific packs)

## How to use effectively

- Start small. Add baseline + one language/framework pack first.
- Add testing packs only when they provide immediate value.
- Treat copied files as local project assets, not locked upstream dependencies.
- Review prompt path examples and adjust to your repository structure.

## Repository structure

- `packs/` — modular pack folders for direct copy/reference usage
- `packs/README.md` — detailed pack catalog and selection guidance
- `.github/copilot-instructions.md` — maintainer guidance for evolving this repository

## For maintainers

When changing packs:

- keep pack intent clear and scoped
- update relevant pack README files
- keep root and pack catalog docs aligned
- use `packs/REVIEW-CHECKLIST.md` before finalizing changes
