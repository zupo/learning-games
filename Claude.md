# Claude Context

## Project Setup

This is a **devenv** project. All commands must be prefixed with `devenv shell`.

## Important Commands

### Building the Project

Always run this command after making changes to Elm code:

```bash
devenv shell build
```

### Other Common Commands

```bash
devenv shell <command>
```

Replace `<command>` with the actual command you need to run within the devenv
environment.

## Workflow

1. Make changes to Elm code
2. Run `devenv shell build`
3. Verify compilation succeeds
4. Test the changes

## Notes

- Never run commands directly without the `devenv shell` prefix
- The build command compiles the Elm code and checks for errors
- This project uses Lamdera, so use `lamdera install` (via devenv shell) for
  adding dependencies
