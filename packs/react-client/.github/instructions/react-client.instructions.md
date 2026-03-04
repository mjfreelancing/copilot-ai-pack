---
applyTo: "{{REACT_CLIENT_APPLY_TO}}"
---

# React Client Instructions

## Core Rules

### Architecture

- Organize by feature modules and shared concerns.
- Keep dependency direction one-way: features may use shared layers.
- Do not edit third-party UI primitives unless explicitly requested.

### State and Data Flow

- Separate server state from UI state.
- Keep API error normalization centralized.
- Use explicit success/failure branching for mutations and async operations.

### UX and Feedback

- Use consistent patterns for blocking errors and transient feedback.
- Keep feedback copy concise and avoid duplicate notifications.
- Keep UI changes aligned with existing design system constraints.

## Expansion Notes

- Keep React-specific patterns here.
- Keep TypeScript-only language rules in `typescript.instructions.md`.
