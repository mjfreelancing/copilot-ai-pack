---
name: dotnet_integration_test
description: Create or update hosted API integration tests with contract-focused assertions.
model: GPT-5.3-Codex (copilot)
---

Create integration tests for API boundary behavior.

## Workflow

1. Place tests under the integration-test project/folder.
2. Assert status code first, then critical contract fields and headers.
3. Use reusable host fixtures for shared setup.
4. Run targeted tests first, then broaden.

## Execution

- `dotnet test {{INTEGRATION_TEST_PROJECT_PATH}} --nologo --verbosity minimal` (from `{{SERVER_ROOT}}`)
