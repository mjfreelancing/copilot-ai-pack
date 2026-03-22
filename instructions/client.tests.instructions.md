---
applyTo: "**/tests/**"
---

# Client Test Instructions

## Core Rules

### Test Design

- Use deterministic tests with mocked external boundaries.
- Prefer behavior-focused assertions over implementation details.
- Mirror source structure in test folders when that improves discoverability.

### Tooling and Naming

- Use the repository's existing client test framework, environment, and shared setup conventions.
- Prefer user-observable assertions and interactions for component and UI tests.
- Keep test naming consistent with the surrounding test project or folder.

### API and Utility Coverage

- Assert on the repository's success and failure contract shape instead of relying on exception-first flows when explicit result objects are used.
- Keep utility tests lightweight and table-driven when that improves readability.
- Keep global test setup changes isolated to the repository's shared test setup entry point.

## Expansion Notes

- Add repository-specific framework names, setup file paths, and command examples in consuming copies of this file.
- Keep project-wide client test behavior here and avoid duplicating it in prompt files.