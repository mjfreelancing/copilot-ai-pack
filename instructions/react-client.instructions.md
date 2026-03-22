---
applyTo: "**/*.{ts,tsx,js,jsx}"
---

# React Client Instructions

## Core Rules

### Architecture

- Organize by feature modules and shared concerns.
- Keep dependency direction one-way: features may use shared layers.
- Prevent shared/cross-cutting layers from depending on feature modules.
- Do not edit third-party UI primitives unless explicitly requested.

### State and Data Flow

- Separate server state from UI state.
- Keep API error normalization centralized.
- Use explicit success/failure branching for mutations and async operations.
- Use centralized auth/logout orchestration instead of scattering logout side effects across unrelated contexts/components.

### UX and Feedback

- Use consistent patterns for blocking errors and transient feedback.
- Keep feedback copy concise and avoid duplicate notifications.
- Enforce one visible blocking error surface at a time to reduce user confusion.
- Keep UI changes aligned with existing design system constraints.

### Auth, Permissions, and Routing

- Use explicit permission guards for conditional rendering and interaction states.
- Prevent self-management lockout patterns (for example excluding current user from bulk admin actions when applicable).

## Expansion Notes

- Keep React-specific patterns here.
- Keep TypeScript-only language rules in `typescript.instructions.md`.
