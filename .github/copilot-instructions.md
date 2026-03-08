# Copilot Instructions for `copilot-ai-pack`

This file is the repository-level operating guide for AI coding agents and maintainers.

## Repository purpose

This repository is the source-of-truth for reusable Copilot asset packs and sync tooling used to apply those assets into other repositories.

Core areas:

- `packs/`: modular asset packs (instructions, prompts, skills/scripts)
- `sync/`: strict sync engine and profile composition
- `templates/`: copy-ready wrapper/task/token templates for consuming repositories

## Current architecture and behavior invariants

These rules are intentional and should be preserved unless explicitly changed by maintainers.

1. **Strict manifests per pack**
   - Every selected pack must include `pack.manifest.json`.
   - `include` is required, `exclude` optional.
   - Missing/invalid manifests are errors (fail-fast).

2. **Strict collision safety**
   - Sync planning detects destination path collisions before writes.
   - On collision, sync fails and writes nothing.

3. **Strict token format**
   - Token replacement supports `{{TOKEN}}` placeholders.

4. **No pack-root README files**
   - Do not add `packs/*/README.md` files.
   - Pack-root READMEs create destination collision risk during sync.
   - Keep pack-level catalog documentation centralized in `packs/README.md` and root `README.md`.

5. **Backward-compatibility requirement must be confirmed**
   - Do not assume backward compatibility is or is not required.
   - Ask the user whether backward compatibility must be preserved before implementing behavior changes.
   - If user direction is absent, pause for clarification instead of choosing implicitly.

## Documentation source-of-truth boundaries

- Root orientation and profile selection: `README.md`
- Pack catalog, pack composition guidance, manifest semantics: `packs/README.md`
- Sync behavior/parameters/safety model: `sync/README.md`
- Wrapper template guidance: `templates/scripts/README.md`
- Task template guidance and profile quick-pick: `templates/tasks/README.md`

Keep docs in present tense and production style. Avoid changelog/journal narration in main docs.

## Expectations for changes

When adding or modifying pack assets:

1. Update the relevant pack files under `packs/<pack>/.github/...`.
2. Ensure `packs/<pack>/pack.manifest.json` correctly includes/excludes those files.
3. Update docs where behavior or guidance changes (`README.md`, `packs/README.md`, `sync/README.md`, template READMEs).
4. Run tests.

When changing sync behavior:

1. Update `sync/sync-copilot-assets.ps1` with strict, explicit validation.
2. Add/adjust tests in `sync/tests/sync-copilot-assets.Tests.ps1`.
3. Verify dry-run/apply semantics remain aligned.
4. Update docs in `sync/README.md` and any affected template/root docs.

When changing templates:

1. Keep wrapper/task parameter mapping consistent with sync script parameters.
2. Reflect mapping changes in `templates/tasks/README.md` and `sync/README.md` compatibility matrix.

## Testing and validation

Primary test command from repository root:

```powershell
./scripts/run-tests.ps1
```

Targeted test command:

```powershell
./scripts/run-tests.ps1 -Path ./sync/tests/sync-copilot-assets.Tests.ps1
```

Expected success summary includes zero failures.

## Style and scope guardrails

- Keep changes focused on requested scope.
- Avoid unrelated refactors.
- Prefer small, explicit, deterministic behavior.
- Maintain naming clarity; avoid ambiguous shorthand.
- Preserve the strict/fail-fast philosophy unless maintainers request a policy change.

## Typical future enhancements (safe direction)

- Expand pack catalog clarity and examples without introducing conflicting docs.
- Add tests for new sync edge-cases before behavior changes.
- Improve template ergonomics while preserving parameter compatibility.
- Add CI wiring for test execution if requested.

## Quick onboarding checklist for a new agent

1. Read `README.md` for current workflow and profile guidance.
2. Read `sync/README.md` for strict behavior contract.
3. Read `packs/README.md` for pack and manifest semantics.
4. If modifying behavior, inspect `sync/tests/sync-copilot-assets.Tests.ps1` first.
5. Make minimal changes, update docs, run tests, and report deltas clearly.
