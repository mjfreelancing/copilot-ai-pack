---
name: dotnet-integration-test
description: Create or update hosted API integration tests with contract-focused assertions. Use when writing integration tests for .NET APIs that exercise HTTP boundary behavior.
---

# .NET Integration Test

Create integration tests for API boundary behavior.

## Workflow

1. Place tests under the integration-test project or folder.
2. Assert status code first, then critical contract fields and headers.
3. Use reusable host fixtures for shared setup.
4. Run targeted tests first, then broaden.

## Execution

Adjust the example paths below to match your repository structure.

- `dotnet test .\Source\Server\My.Api.Integration.Tests\My.Api.Integration.Tests.csproj --nologo --verbosity minimal` (from `.\Source\Server`)

## Repository Notes

- Keep repository-specific host fixture and path details in consuming copies.
- Keep shared integration architecture rules in instruction files.
