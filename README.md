# copilot-ai-pack

Reusable Copilot asset packs for teams that want a simple, manual copy-and-adapt workflow.

## Purpose

This repository provides modular Copilot assets that you can copy into your own repository and customize locally.

What this repository offers:

- instruction packs for language/framework behavior
- testing prompts for common workflows
- an optional agent setup and readiness tools pack

The operating model is intentionally straightforward: pick the packs you need, copy the relevant source files into `.github`, and adapt them to your repository.

## Quick start

1. Open `packs/README.md` and pick packs for your stack.
2. Copy source files from `packs/instructions/`, `packs/prompts/`, and `packs/skills/` into the matching `.github/` folders in your repository.
3. Keep the copied files that fit your workflow; edit as needed.
4. Commit changes in your repository.

## Recommended starter combinations

| Repository type                                  | Suggested packs                                                                                                                |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| .NET backend/service                             | `language-agnostic-core` <br> `csharp-core` <br> `dotnet-unit-tests`                                                           |
| ASP.NET Core API                                 | `language-agnostic-core` <br> `csharp-core` <br> `aspnetcore-api` <br> `aspnetcore-integration-tests` <br> `dotnet-unit-tests` |
| Postgres + EF Core                               | `language-agnostic-core` <br> `csharp-core` <br> `postgres-efcore`                                                             |
| React + TypeScript client                        | `language-agnostic-core` <br> `typescript-core` <br> `react-client` <br> `prompts-testing`                                     |
| Any repo needing agent setup and readiness tools | `agent-env-tools`                                                                                                              |

## What you copy

Source assets in this repository are organized by asset type under `packs/` and are copied into `.github/` folders in the consuming repository.

Common asset types:

- `packs/instructions/*.instructions.md` -> copy into `.github/instructions/`
- `packs/prompts/*.prompt.md` -> copy into `.github/prompts/`
- `packs/skills/<pack>/**` -> copy into `.github/skills/<pack>/` (including any scripts/resources used by that skill)

## How to use effectively

- Start small. Add baseline + one language/framework pack first.
- Add testing packs only when they provide immediate value.
- Treat copied files as local project assets, not locked upstream dependencies.
- Review prompt path examples and adjust to your repository structure.

## Repository structure

- `packs/instructions/` — instruction source files
- `packs/instructions/README.md` — instruction file index for maintainers
- `packs/prompts/` — prompt source files
- `packs/prompts/README.md` — prompt file index for maintainers
- `packs/skills/` — skill source files grouped by pack
- `packs/skills/agent-env-tools/SKILL.md` — agent tooling skill definition
- `packs/skills/agent-env-tools/scripts/agent-env-tools.ps1` — agent environment diagnostics script used by the skill
- `packs/README.md` — detailed pack catalog and selection guidance
- `.github/copilot-instructions.md` — maintainer guidance for evolving this repository

## For maintainers

When changing packs:

- keep pack intent clear and scoped
- update the relevant type-level or pack-level README files
- keep root and pack catalog docs aligned
