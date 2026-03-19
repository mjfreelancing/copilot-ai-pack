# agent-env-tools

## Purpose

Provide reusable environment diagnostics guidance before coding sessions.

## When to use

- You want a standard preflight check for required and optional tools.
- You want a reusable skill and script for environment readiness.

## What it provides

- `.github/skills/README.md`
- `.github/skills/agent-env-tools/SKILL.md`
- `.github/scripts/README.md`
- `.github/scripts/agent-env-diagnostics.ps1`

## Best paired with

- Any repository where agents run coding/test workflows and require predictable tooling.

## Not intended for

- Replacing project-level build/test scripts.
- Installing required production dependencies automatically.

## Manual integration

Copy this pack's `.github` content into your target repository.
