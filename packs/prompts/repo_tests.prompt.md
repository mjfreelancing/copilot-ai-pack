---
name: repo_tests
description: Run repository test suites with project defaults, then summarize failures.
---

Run tests using repository defaults.

## Workflow

1. Start with smallest relevant scope.
2. Summarize failures and root messages before fixes.
3. Broaden only when needed.

## Commands

Adjust the example paths below to match your repository structure.

- .NET: `dotnet test .\Source\Server\MySolution.sln -c Debug --nologo --verbosity minimal` (from `.\Source\Server`)
- JS/TS: `npm run test` (from `.\Source\Client\my-app`)
