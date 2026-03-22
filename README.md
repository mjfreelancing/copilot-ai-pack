# copilot-ai-pack

Reusable Copilot assets for teams that want a simple, manual copy-and-adapt workflow.

## Purpose

This repository is the source of truth for reusable Copilot assets that can be copied into another repository and adapted locally.

What this repository includes:

- instructions for language, framework, testing, and workflow behavior
- prompts for common testing tasks
- scripts for environment diagnostics and setup support

The operating model is deliberately simple: pick the assets that fit your stack, copy them into `.github` in the consuming repository, and edit them there.

## Quick start

1. Read the catalog sections below and choose the assets that match your repository.
2. Copy selected files from `instructions/`, `prompts/`, and `scripts/` into the matching `.github/` folders in your repository.
3. Adjust copied content to your repository structure and conventions.
4. Commit the copied files in the consuming repository.

## What to copy

- `instructions/*.instructions.md` -> `.github/instructions/`
- `prompts/*.prompt.md` -> `.github/prompts/`
- `scripts/<pack>/...` -> `.github/scripts/<pack>/`

## How to choose quickly

- Start with `language-agnostic-core.instructions.md`.
- Add language-specific instructions next, such as `csharp.instructions.md` or `typescript.instructions.md`.
- Add framework or database instructions only if your repository needs them.
- Add prompts when you want task entry points for test work.
- Add `scripts/agent-env-tools/` when you want agents to confirm the environment is ready before starting a session.

## Recommended combinations

| Repository type                                 | Suggested assets                                                                                                                                                                                     |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| .NET backend or service                         | `language-agnostic-core.instructions.md` <br> `csharp.instructions.md` <br> `dotnet.tests.instructions.md`                                                                                           |
| ASP.NET Core API                                | `language-agnostic-core.instructions.md` <br> `csharp.instructions.md` <br> `aspnetcore-api.instructions.md` <br> `aspnetcore.integration-tests.instructions.md` <br> `dotnet.tests.instructions.md` |
| PostgreSQL with EF Core                         | `language-agnostic-core.instructions.md` <br> `csharp.instructions.md` <br> `postgres-efcore.instructions.md`                                                                                        |
| React and TypeScript client                     | `language-agnostic-core.instructions.md` <br> `typescript.instructions.md` <br> `react-client.instructions.md` <br> one or more prompt files from `prompts/`                                         |
| Any stack where agent session readiness matters | `scripts/agent-env-tools/`                                                                                                                                                                           |

## Asset catalog

### Instructions

Use these when you want always-on guidance copied into `.github/instructions/` in a consuming repository.

| File                                           | Use when                                                                         |
| ---------------------------------------------- | -------------------------------------------------------------------------------- |
| `language-agnostic-core.instructions.md`       | You want baseline coding behavior that applies across stacks.                    |
| `csharp.instructions.md`                       | The repository has C# or .NET production code.                                   |
| `typescript.instructions.md`                   | The repository has TypeScript code and needs language-level guardrails.          |
| `react-client.instructions.md`                 | The repository includes a React frontend.                                        |
| `aspnetcore-api.instructions.md`               | The repository exposes ASP.NET Core API endpoints.                               |
| `aspnetcore.integration-tests.instructions.md` | You run hosted API tests through real HTTP pipeline behavior.                    |
| `dotnet.tests.instructions.md`                 | You want deterministic .NET unit testing conventions.                            |
| `server.instructions.md`                       | You want server-layer architecture and persistence workflow guidance.            |
| `client.tests.instructions.md`                 | You want client test conventions separated from production client rules.         |
| `postgres-efcore.instructions.md`              | The repository uses EF Core with PostgreSQL and migration-driven schema changes. |
| `docker.instructions.md`                       | The repository includes Docker workflow or container validation work.            |

Instruction notes:

- Treat `csharp.instructions.md` as baseline C# guidance and `aspnetcore-api.instructions.md` as API-specific refinement when both are used.
- `aspnetcore.integration-tests.instructions.md` complements API and test guidance rather than replacing it.
- `postgres-efcore.instructions.md` is most useful alongside C# and API guidance in DB-backed services.

### Prompts

Use these when you want reusable task entry points copied into `.github/prompts/`.

| File                                | Use when                                                                |
| ----------------------------------- | ----------------------------------------------------------------------- |
| `repo_tests.prompt.md`              | You want an agent to run repository test suites and summarize failures. |
| `typescript_tests.prompt.md`        | You want an agent to create or update TypeScript tests.                 |
| `client_tests.prompt.md`            | You want an agent to create or update web client tests.                 |
| `dotnet_unit_test.prompt.md`        | You want an agent to create or update .NET unit tests.                  |
| `server_unit_test.prompt.md`        | You want an agent to create or update server unit tests.                |
| `dotnet_integration_test.prompt.md` | You want an agent to create or update hosted API integration tests.     |
| `server_integration_test.prompt.md` | You want an agent to create or update server integration tests.         |
| `code_coverage.prompt.md`           | You want an agent to run repository coverage and summarize results.     |
| `docker_workflow.prompt.md`         | You want an agent to run repository Docker lifecycle workflows.         |
| `document_csharp.prompt.md`         | You want an agent to add or update XML docs for C# code.                |
| `document_typescript.prompt.md`     | You want an agent to add or update TSDoc or JSDoc for TypeScript code.  |
| `feature_implementation.prompt.md`  | You want an agent to implement a feature with a focused checklist.      |

Prompt notes:

- Prompt path examples are templates and should be adjusted to the consuming repository.
- Prompt files work well alongside the related instruction files rather than as a substitute for them.

### Scripts

Use these when you want a copyable utility rather than an always-on instruction or a chat prompt.

#### `agent-env-tools`

Use when:

- You want agents to verify the environment is ready before starting a session.
- You also want developers to run the same check manually.

Provides:

- A PowerShell diagnostics script that checks required and optional CLI tools.
- A README covering both agent and developer use, with troubleshooting guidance.

Copy target:

- `.github\scripts\agent-env-tools\`

Main files:

- `scripts/agent-env-tools/README.md`
- `scripts/agent-env-tools/agent-env-tools.ps1`

## Repository structure

- `instructions/` — instruction source files and their index README
- `prompts/` — prompt source files and their index README
- `scripts/` — script-based utility packs and their index README
- `scripts/agent-env-tools/` — environment diagnostics script pack
- `.github/copilot-instructions.md` — maintainer guidance for evolving this repository

## Maintainer notes

When changing assets:

- keep the asset intent clear and scoped
- update the relevant folder README files when files or guidance change
- keep this root README aligned with the actual repository structure and copy targets
