# Scripts

This folder contains reusable automation scripts for local diagnostics and workflow support.

## Purpose

Provide discoverable entry points for local automation scripts.

## Contents

- `agent-env-diagnostics.ps1`
  - Validates required/optional tooling.
  - Explains missing-tool purpose.
  - Supports optional install flows (`-OfferInstall`, `-AutoInstall`, `-DryRun`).

## Source of truth boundary

- Keep detailed command behavior in the script itself.
- Keep this file as a discoverability index.

## Notes

### Typical AI agent usage

- Agents typically run diagnostics in report-only mode first to assess environment readiness.
- If optional tools are missing, agents use `-OfferInstall` (interactive) or `-AutoInstall -DryRun` (preview) before making changes.
- Install-capable modes are opt-in; agents should not perform machine changes unless explicitly requested.

### Manual usage

Run from repository root:

- `.\.github\scripts\agent-env-diagnostics.ps1`
