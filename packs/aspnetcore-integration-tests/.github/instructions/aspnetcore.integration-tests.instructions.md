---
applyTo: "**/*Integration.Tests/**/*.cs"
---

# ASP.NET Core Integration Test Instructions

## Core Rules

### Classification

- Use integration tests when behavior must be verified through hosted API pipeline + real HTTP requests.
- Keep unit tests in unit test projects; avoid host bootstrapping for unit scope.

### Organization and Assertions

- Organize tests by feature and cross-cutting concerns.
- Assert HTTP status first, then contract fields and headers.
- Prefer typed response models over ad-hoc JSON traversal.

### Reliability

- Start with targeted fixture/test execution, then broaden scope.
- Keep shared host setup in reusable factory fixtures.

## Expansion Notes

- Keep endpoint-family patterns in this file.
- Keep generic unit-test rules in `dotnet.tests.instructions.md`.
