---
applyTo: "**/*.cs"
---

# ASP.NET Core API Instructions

## Core Rules

### Layering and Feature Design

- Keep HTTP/API concerns, application/domain logic, and persistence concerns in separate layers.
- Prefer vertical-slice organization per feature or operation.
- Keep handlers thin and focused on orchestration: validate, map input, call service, and map result to the transport boundary.

### Endpoint and Validation

- Keep endpoint registrations explicit and discoverable, using the repository's established composition pattern for endpoint and transport wiring.
- Follow the repository's existing request validation and error-response conventions, keeping ProblemDetails mapping consistent.

### Contracts and Security

- Keep API contracts stable and explicit, using external identifiers instead of leaking internal persistence identifiers.
- Enforce authorization at endpoint/service boundaries, respecting tenant or scope isolation patterns already established by the repository.
- Avoid leaking sensitive request/header data in errors.

### Data and Persistence

- Use the existing repository and unit-of-work conventions when they already exist.
- Default reads to no-tracking and opt into tracking only for write paths when applicable.
- Keep schema and migration changes isolated to the repository's dedicated migration workflow (for example the migrations project).
- Treat migration generation as a developer-reviewed step unless the user explicitly asks for it.

### Runtime and Health

- Preserve documented health or readiness endpoints and keep health checks available and stable when modifying runtime startup or infrastructure behavior.

## Expansion Notes

- Add repository-specific commands, project names, and paths in consuming copies of this file.
- Keep transport and persistence rules in the subsection that matches the affected lifecycle stage.
- Keep persistence-provider specifics (for example Postgres/EF conventions) in provider-specific instruction packs.
- Move language-level rules to `csharp.instructions.md` or another language-specific baseline instead of duplicating them here.
