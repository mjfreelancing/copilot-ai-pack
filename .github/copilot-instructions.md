# Copilot Instructions for `copilot-ai-pack`

This file is the repository-level operating guide for AI coding agents and maintainers.

## Repository purpose

This repository is the source-of-truth for reusable Copilot asset packs that users can copy and adapt manually in their own repositories.

Core areas:

- `packs/`: modular asset packs (instructions, prompts, skills/scripts)

## Maintainer principles

These principles keep the repository focused and maintainable.

1. **Pack-first design**
   - Prefer small, composable packs with clear intent.
   - Keep pack files practical and editable by consuming teams.

2. **Clarity over automation**
   - Favor straightforward content and documentation over complex orchestration.
   - Assume users will copy and adapt packs manually.

3. **Minimal maintenance surface**
   - Avoid introducing infrastructure that requires ongoing operational overhead.
   - Keep changes explicit, deterministic, and easy to review.

4. **Policy alignment before behavior changes**
   - Confirm compatibility expectations before major behavior changes.
   - If direction is absent, pause and ask.

## Documentation source-of-truth boundaries

- Root orientation and usage model: `README.md`
- Pack catalog and adoption guidance: `packs/README.md`
- Instruction file index: `packs/instructions/README.md`
- Prompt file index: `packs/prompts/README.md`
- Multi-file pack notes: `packs/skills/agent-env-tools/SKILL.md`, `packs/skills/agent-env-tools/scripts/agent-env-tools.ps1`

## Expectations for changes

When adding or modifying pack assets:

1. Update the relevant pack files under `packs/instructions/`, `packs/prompts/`, or `packs/skills/<pack>/...` as appropriate.
2. Keep the relevant type-level or pack-level `README.md` in sync with pack intent and usage.
3. Update root docs when behavior or guidance changes (`README.md`, `packs/README.md`).
4. Validate content quality through focused review of changed pack files.

## Style and scope guardrails

- Keep changes focused on requested scope.
- Avoid unrelated refactors.
- Prefer small, explicit, deterministic behavior.
- Maintain naming clarity; avoid ambiguous shorthand.
- Use Windows path delimiters (`\`) for PowerShell scripts and command examples in this repository.
- Preserve simplicity unless maintainers explicitly request added complexity.

## Typical future enhancements (safe direction)

- Improve pack clarity and examples.
- Refine pack boundaries to reduce overlap.
- De-tokenize legacy placeholders where still present.

## Quick onboarding checklist for a new agent

1. Read `README.md` for current workflow and pack selection model.
2. Read `packs/README.md` for pack selection and integration guidance.
3. Read `packs/instructions/README.md`, `packs/prompts/README.md`, `packs/skills/agent-env-tools/SKILL.md`, or `packs/skills/agent-env-tools/scripts/agent-env-tools.ps1` as relevant to the changed assets.
4. Make minimal changes and keep docs aligned with edited packs.
