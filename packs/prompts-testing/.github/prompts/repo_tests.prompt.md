---
name: repo_tests
description: Run repository test suites with project defaults, then summarize failures.
model: GPT-5.3-Codex (copilot)
---

Run tests using repository defaults.

## Workflow

1. Start with smallest relevant scope.
2. Summarize failures and root messages before fixes.
3. Broaden only when needed.

## Commands

- .NET: `dotnet test {{SERVER_SOLUTION_FILE}} -c Debug --nologo --verbosity minimal` (from `{{SERVER_ROOT}}`)
- JS/TS: `npm run test` (from `{{CLIENT_ROOT}}`)
