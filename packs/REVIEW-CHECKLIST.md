# Pack Review Checklist

Use this checklist during review before merging pack changes.

Primary audience: human maintainers.
AI agents can use it when instructed by `.github/copilot-instructions.md`.
This checklist is for maintaining this repository, not for copying into consuming repositories.

## Scope and intent

- Change scope is limited to requested behavior.
- Pack `README.md` still matches pack intent and assets.
- Root docs stay aligned when behavior/guidance changed:
  - `README.md`
  - `packs/README.md`
  - `.github/copilot-instructions.md` (if maintainer workflow changed)

## Fact correctness

- All repo-relative paths in docs/scripts exist.
- No references remain to removed architecture/features (`sync`, `templates`, `profiles`, token pipeline).
- Pack names are consistent everywhere (for example `agent-env-tools` vs legacy names).

## Instruction and prompt quality

- `applyTo` patterns are intentional and documented when narrow or broad.
- Overlapping instruction packs include a documented interpretation strategy.
- Prompt command examples include clear path-customization guidance.
- Prompt metadata avoids environment-specific model pinning unless intentionally required.

## Script and skill consistency

- Script header comments reference current docs/skills only.
- Skill docs and script docs reference each other consistently.
- Safety/opt-in behavior in script docs matches actual script behavior.

## Final verification

- `grep`/`rg` sweep for stale terms returns no actionable hits.
- Edited files have no lint/parse errors in VS Code Problems.
- Changes are minimal, explicit, and easy to review.

### Optional quick checks (from repo root)

- Stale architecture terms:
  - `rg -n "environment-preflight|sync/|templates/|pack.manifest|automation-playbook" --hidden --glob "!.git"`
- Remaining token placeholders:
  - `rg -n "\{\{[A-Z0-9_]+\}\}" --hidden --glob "!.git"`
- Internal path references to validate:
  - `rg -n -o "\.github/[A-Za-z0-9_./-]+|packs/[A-Za-z0-9_./-]+" -g "*.md" -g "*.ps1" --hidden --glob "!.git"`