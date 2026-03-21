# Instructions

This folder contains instruction source files that are copied into `.github/instructions/` in a consuming repository.

## Copy target

Copy the selected `*.instructions.md` files from this folder into `.github/instructions/` in your target repository.

## Available files

| File                                           | Description                                               |
| ---------------------------------------------- | --------------------------------------------------------- |
| `language-agnostic-core.instructions.md`       | Baseline coding behavior that applies across stacks.      |
| `csharp.instructions.md`                       | Core C# and .NET guidance.                                |
| `typescript.instructions.md`                   | Core TypeScript guidance.                                 |
| `react-client.instructions.md`                 | React client architecture and UI guidance.                |
| `aspnetcore-api.instructions.md`               | ASP.NET Core API endpoint and contract guidance.          |
| `aspnetcore.integration-tests.instructions.md` | ASP.NET Core hosted integration testing guidance.         |
| `dotnet.tests.instructions.md`                 | Deterministic .NET unit testing guidance.                 |
| `postgres-efcore.instructions.md`              | PostgreSQL and EF Core modeling/query/migration guidance. |
| `docker.instructions.md`                       | Docker workflow safety and validation guidance.           |

## Notes

- These files are stored flat to mirror the final `.github/instructions/` structure.
- Adjust `applyTo` values after copying if your repository layout differs from the examples.
- See `../README.md` for pack combinations and adoption guidance.
