---
name: docker-workflow
description: Run Docker lifecycle workflows including build, start, stop, status, and health checks using repository task and compose wrappers. Use when working with Docker containers, compose services, or container lifecycle tasks.
license: MIT
---

# Docker Workflow

Handle Docker workflows using the safest, most repeatable repository path.

## Scope

- Handle build, start, stop, status, and health-check workflows for the existing stack.

## Workflow

1. Prefer repository task or command wrappers over ad-hoc shell sequences.
2. Validate health and status after lifecycle changes.

## Commands and Rules

- Prefer VS Code tasks or documented wrapper commands first.
- Use the repository's compose file or orchestration manifests when direct commands are required.
- Include required environment files or flags when repository docs specify them.
- Never modify persisted data folders or volumes unless the user explicitly asks.

## Validation

- Confirm expected services or containers are running.
- Confirm documented health or status endpoints respond when available.

If a step fails, summarize the root error and provide the smallest next corrective step.

## Repository Notes

- Add repository-specific task names, compose paths, endpoints, and safety boundaries in consuming copies.
- Keep service-specific safety rules aligned with any Docker instruction file used by the repository.
