---
name: docker_workflow
description: Run Docker lifecycle workflows with task-first defaults.
---

Handle Docker workflows using the safest, most repeatable repository path.

## Scope

- Handle build, start, stop, status, and health-check workflows for the existing stack.

## Workflow

- Prefer repository task or command wrappers over ad-hoc shell sequences.
- Validate health and status after lifecycle changes.

## Commands and Rules

- Prefer VS Code tasks or documented wrapper commands first.
- Use the repository's compose file or orchestration manifests when direct commands are required.
- Include required environment files or flags when repository docs specify them.
- Never modify persisted data folders or volumes unless the user explicitly asks.

## Validation

- Confirm expected services or containers are running.
- Confirm documented health or status endpoints respond when available.

If a step fails, summarize the root error and provide the smallest next corrective step.

## Expansion Notes

- Add repository-specific task names, compose paths, endpoints, and safety boundaries in consuming copies.
- Keep service-specific safety rules aligned with any Docker instruction file used by the repository.