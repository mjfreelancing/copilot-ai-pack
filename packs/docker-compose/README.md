# docker-compose

## Purpose

Guidance for safe Docker Compose workflows and lifecycle operations.

## When to use

- Your repository uses Docker Compose for local or integration environments.
- You want operational safety checks around container workflows.

## What it provides

- `.github/instructions/docker.instructions.md`

Note:

- The instruction file currently scopes to `**/Docker/**`. Adjust `applyTo` in your copied instruction file if your repository uses a different Docker file layout.

## Best paired with

- Any stack that runs local infrastructure via containers.

## Not intended for

- Defining service-specific compose files for your application.

## Manual integration

Copy this pack's `.github` content into your target repository.
