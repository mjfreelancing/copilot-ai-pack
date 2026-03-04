---
applyTo: "{{DOCKER_APPLY_TO}}"
---

# Docker Workflow Instructions

## Core Rules

### Lifecycle

- Prefer workspace task wrappers over ad-hoc shell sequences.
- Keep compose command usage explicit and repeatable.
- Validate service health after lifecycle changes.

### Safety

- Treat runtime volume/data directories as protected unless explicitly requested.
- Keep Dockerfile/compose edits minimal and focused on requested behavior.

### Validation

- Verify containers are running.
- Verify configured API and client health endpoints respond.

## Expansion Notes

- Keep task names and compose file paths in project-specific overlays or token files.
