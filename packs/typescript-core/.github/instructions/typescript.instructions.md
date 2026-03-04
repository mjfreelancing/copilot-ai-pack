---
applyTo: "{{TYPESCRIPT_APPLY_TO}}"
---

# TypeScript Instructions

## Core Rules

### Language and Style

- Prefer explicit types and `type` aliases where practical.
- Do not use `any` unless unavoidable at a boundary.
- Always use braces for `if` statements, including single-line branches.
- Keep modules small and cohesive.

### Runtime Behavior

- Keep state-changing operations in handlers/effects, not in render paths.

## Expansion Notes

- Baseline cross-language rules live in `language-agnostic-core.instructions.md`.
- Keep framework-agnostic TypeScript-only rules here.
- Put React- or API-specific conventions in separate instruction packs.
