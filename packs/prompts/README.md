# Prompts

This folder contains prompt source files that are copied into `.github/prompts/` in a consuming repository.

## Copy target

Copy the selected `*.prompt.md` files from this folder into `.github/prompts/` in your target repository.

## Available files

| File                                | Description                                        |
| ----------------------------------- | -------------------------------------------------- |
| `repo_tests.prompt.md`              | Run repository test suites and summarize failures. |
| `typescript_tests.prompt.md`        | Create or update TypeScript and JavaScript tests.  |
| `dotnet_unit_test.prompt.md`        | Create or update .NET unit tests.                  |
| `dotnet_integration_test.prompt.md` | Create or update hosted API integration tests.     |

## Notes

- These files are stored flat to mirror the final `.github/prompts/` structure.
- Prompt examples include sample paths that should be adjusted to match the consuming repository.
- See `../README.md` for pack combinations and adoption guidance.
