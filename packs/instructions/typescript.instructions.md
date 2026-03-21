---
applyTo: "**/*.{ts,tsx}"
---

# TypeScript Instructions

## Core Rules

### Language and Style

- Prefer explicit types and `type` aliases where practical.
- Do not use `any` unless unavoidable at a boundary.
- Prefer function declarations over arrow functions for exported utilities where practical.
- Always use braces for `if` statements, including single-line branches.
- Keep a blank line before and after multi-line `if` blocks for readability consistency.
- Keep modules small and cohesive.

### Runtime Behavior

- Keep state-changing operations in handlers/effects, not in render paths.

## Expansion Notes

- Baseline cross-language rules live in `language-agnostic-core.instructions.md`.
- Keep framework-agnostic TypeScript-only rules here.
- Put React- or API-specific conventions in separate instruction packs.
