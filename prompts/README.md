# Prompts

This folder contains prompt source files that are copied into `.github/prompts/` in a consuming repository.

## Copy target

Copy the selected `*.prompt.md` files from this folder into `.github/prompts/` in your target repository.

## Available files

| File                                | Description                                        |
| ----------------------------------- | -------------------------------------------------- |
| `repo_tests.prompt.md`              | Run repository test suites and summarize failures. |
| `typescript_tests.prompt.md`        | Create or update TypeScript tests.                 |
| `client_tests.prompt.md`            | Create or update client tests.                     |
| `dotnet_unit_test.prompt.md`        | Create or update .NET unit tests.                  |
| `server_unit_test.prompt.md`        | Create or update server unit tests.                |
| `dotnet_integration_test.prompt.md` | Create or update hosted API integration tests.     |
| `server_integration_test.prompt.md` | Create or update server API integration tests.     |
| `code_coverage.prompt.md`           | Run repository coverage and summarize results.     |
| `docker_workflow.prompt.md`         | Run Docker lifecycle workflows safely.             |
| `document_csharp.prompt.md`         | Document C# classes and public APIs with XML docs. |
| `document_typescript.prompt.md`     | Document TypeScript modules and components.        |
| `feature_implementation.prompt.md`  | Implement features with a focused checklist.       |

## Notes

- These files are stored flat to mirror the final `.github/prompts/` structure.
- Prompt examples include sample paths that should be adjusted to match the consuming repository.
- See `../README.md` for asset combinations and adoption guidance.

## Baseline and Mirror Workflow

Use this workflow for prompt files that combine reusable guidance with repository-specific additions.

1. Keep reusable, cross-project prompts in this repository under `prompts/*.prompt.md`.
2. In consuming repositories, mirror the file structure and keep the same prompt section layout when applicable.
3. Treat shared prompt intent and core execution flow as baseline-owned. Do not fork baseline behavior unless a baseline update is intentionally deferred.
4. Put repository-specific behavior in repository-local prompt additions (for example path examples, stack-specific commands, fixture/setup commands, and acceptance checks).
5. When baseline prompt files change, sync mirrors by:
   - copying updated baseline prompt content,
   - preserving only repository-specific additions,
   - confirming file names and references are correct for the target repository layout.

Recommended review check:

- Baseline prompt intent and execution flow remain equivalent between baseline and mirror.
- Mirror-only content is limited to repository-specific paths, commands, and context.
- Tone and heading structure match other prompt files in the repository.
