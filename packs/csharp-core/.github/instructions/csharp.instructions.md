---
applyTo: "**/*.cs"
---

# C# Instructions

## Core Rules

### Language and Code Quality

- Treat `.editorconfig` as the source of truth for formatting and analyzer style rules.
- Avoid sync-over-async (`.Result`, `.Wait()`, `.GetAwaiter().GetResult()`).
- Keep `CancellationToken` propagation intact in async chains.
- Implement with testability in mind; prefer constructor injection and avoid static dependencies.
- Default to sealed classes unless extensibility is required.

### C# Architecture

- Keep handlers thin: validate, map input, call service, map result.

## Expansion Notes

- Baseline cross-language rules live in `language-agnostic-core.instructions.md`.
- Keep C#-specific conventions in this file.
- Move project- or layer-specific rules to additional scoped instruction files.
