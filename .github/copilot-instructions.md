# Copilot Instructions for `copilot-ai-pack`

This file is the repository-level operating guide for AI coding agents and maintainers.

## Repository purpose

This repository is the source-of-truth for reusable Copilot assets that users can copy and adapt manually in their own repositories.

Core areas:

- `instructions/`: instruction source files
- `prompts/`: prompt source files
- `skills/`: skill source folders
- `scripts/`: script-based utility packs

## Maintainer principles

These principles keep the repository focused and maintainable.

1. **Asset-first design**
   - Prefer small, composable assets with clear intent.
   - Keep source files practical and editable by consuming teams.

2. **Clarity over automation**
   - Favor straightforward content and documentation over complex orchestration.
   - Assume users will copy and adapt assets manually.

3. **Minimal maintenance surface**
   - Avoid introducing infrastructure that requires ongoing operational overhead.
   - Keep changes explicit, deterministic, and easy to review.

4. **Policy alignment before behavior changes**
   - Confirm compatibility expectations before major behavior changes.
   - If direction is absent, pause and ask.

## Documentation source-of-truth boundaries

- Root orientation and usage model: `README.md`
- Root catalog and adoption guidance: `README.md`
- Instruction file index: `instructions/README.md`
- Prompt file index: `prompts/README.md`
- Skill file index: `skills/README.md`
- Script file index: `scripts/README.md`
- Script asset notes: `scripts/agent-env-tools/README.md`, `scripts/agent-env-tools/agent-env-tools.ps1`

## Expectations for changes

When adding or modifying repository assets:

1. Update the relevant files under `instructions/`, `prompts/`, `skills/`, or `scripts/<pack>/...` as appropriate.
2. Keep the relevant type-level or script-folder `README.md` in sync with asset intent and usage.
3. Update root docs when behavior or guidance changes (`README.md` and any relevant folder-level `README.md`).
4. Validate content quality through focused review of changed asset files.

## Style and scope guardrails

- Keep changes focused on requested scope.
- Avoid unrelated refactors.
- Prefer small, explicit, deterministic behavior.
- Maintain naming clarity; avoid ambiguous shorthand.
- Use Windows path delimiters (`\`) for PowerShell scripts and command examples in this repository.
- Preserve simplicity unless maintainers explicitly request added complexity.

## Quick onboarding checklist for a new agent

1. Read `README.md` for current workflow and asset selection model.
2. Read `instructions/README.md`, `prompts/README.md`, `skills/README.md`, or `scripts/README.md` as relevant to the changed assets.
3. Read `scripts/agent-env-tools/README.md` or `scripts/agent-env-tools/agent-env-tools.ps1` when working on the environment diagnostics script folder.
4. Make minimal changes and keep docs aligned with edited assets.
