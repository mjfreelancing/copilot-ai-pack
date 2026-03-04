---
name: dotnet_unit_test
description: Create or update .NET unit tests with deterministic setup and focused assertions.
model: GPT-5.3-Codex (copilot)
---

Create unit tests for .NET code.

## Workflow

1. Place tests in the nearest unit-test project for the changed code.
2. Follow scoped instruction files for style and assertion conventions.
3. Add deterministic setup and behavior-focused assertions.
4. Run smallest relevant test scope first, then broaden.

## Execution

- `dotnet test {{SERVER_SOLUTION_FILE}} -c Debug --nologo --verbosity minimal` (from `{{SERVER_ROOT}}`)
