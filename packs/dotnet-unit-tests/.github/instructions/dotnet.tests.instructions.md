---
applyTo: "{{DOTNET_TESTS_APPLY_TO}}"
---

# .NET Test Instructions

## Core Rules

### Scope and Isolation

- Keep tests deterministic and isolated from external systems.
- Prefer behavior and contract assertions over implementation details.
- Keep unit and integration tests separated by project responsibility.

### Conventions

- Use xUnit naming and structure consistent with the repository.
- Keep assertion style consistent within each test project.
- Keep reusable helpers in a shared test utility project when they are cross-project.

### Placement

- Unit tests: project-level test projects that validate in-process behavior.
- Integration tests: hosted API or end-to-end boundary tests with real HTTP/database boundaries.

## Expansion Notes

- Keep framework/tooling choices in project-level docs if needed.
- Add layer-specific conventions in dedicated scoped files.
