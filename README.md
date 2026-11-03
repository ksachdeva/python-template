# Python Project Template

A starting point for Python projects, developed in a VS Code Dev Container. The container uses Python 3.14, `uv` for environment and dependency management, Poe the Poet for project tasks, and pre-commit for checks and formatting.

## Getting Started

Prerequisites:

- Docker
- Visual Studio Code with the Dev Containers extension

Open the repository in VS Code and run **Dev Containers: Reopen in Container** from the Command Palette. On first creation, the container installs the project dependencies with `uv sync`, configures shell completions, installs OpenCode and APM, and installs the Git pre-commit hooks.

The project requires Python 3.14 or newer (`requires-python` in `pyproject.toml`); the development container currently uses Python 3.14 on Debian Trixie.

## Poe Tasks

Poe tasks are declared in `poe.toml`. In the container, a `poe` shell command is provided that runs Poe through `uv`; you can also invoke it explicitly with `uv run poe`.

| Command | What it does |
| --- | --- |
| `poe fmt` | Formats Python code with `uv format`. |
| `poe pre-commit` | Runs all configured pre-commit hooks against all files. |
| `poe --help` | Lists available tasks. |

The same tasks can be run outside the container as `uv run poe fmt` and `uv run poe pre-commit`. The current task list is intentionally small; run other tools through `uv run`, for example `uv run pytest` or `uv run ruff check .`.

Dependencies are managed with `uv`. Add runtime dependencies with `uv add <package>` and development dependencies with `uv add --dev <package>`. These commands update `pyproject.toml` and `uv.lock`.

## What's in the Dev Container

- Python 3.14 on Debian Trixie, plus build tools and the configured certificate trust for network tools.
- `uv`, Node.js 24, `pnpm`, TypeScript, `ts-node`, ripgrep, and Docker CLI access through the Docker-outside-of-Docker feature.
- Zsh as the default shell, with completions for `uv`, Docker, and Poe.
- VS Code extensions for Python, Ruff, mypy, Prettier, and Mermaid. Python files use Ruff for format-on-save; JavaScript and TypeScript use Prettier.
- Pre-commit hooks for common file checks, Ruff linting/formatting, `uv.lock` consistency, and Prettier.

The post-create scripts also configure the `ys` Zsh theme, append shell history to a shared file, install OpenCode and APM, and install the repository's pre-commit hooks. To update the container's tools or features, edit `.devcontainer/devcontainer.json`, `.devcontainer/Dockerfile`, or the scripts under `.devcontainer/scripts`, then rebuild the container.

## Persistent Container Data

Docker named volumes keep selected data across container rebuilds:

- `devcontainer-zshhistory` stores Zsh history at `/commandhistory/.zsh_history`.
- `devcontainer-opencode` stores OpenCode's database at `/opencode-storage/opencode.db`.

These are Docker-managed volumes, not folders in the repository. Removing a volume removes its data; rebuilding the container alone does not.

## OpenCode with Host Ollama

OpenCode is installed globally in the container. The sample configuration is in `.opencode/opencode.jsonc`; it defines an OpenAI-compatible provider named `host-ollama` with base URL `http://host.docker.internal:11434/v1`.

This assumes Ollama is running on the host machine and its API is reachable from the container on port `11434`. The Dev Container adds `host.docker.internal` as a route to the host. Start Ollama and make sure its API is available to the container; do not expose it to untrusted networks. The model names in the sample (`gemma4:12b-mlx`, `gemma4:31b-mlx`, and `qwen3.8:27b-mlx`) are examples: replace them with model identifiers available from your Ollama server.

The file is a project sample; if your OpenCode installation does not load it automatically, merge its provider definition into the OpenCode configuration location used by your version. The database path is set separately by the container's `OPENCODE_DB` environment variable and backed by the persistent volume above.

## APM

[APM (Agent Package Manager)](https://microsoft.github.io/apm) is installed during container creation. It manages agent packages from a project manifest and installs supported artifacts such as commands, prompts, skills, and MCP servers for the selected agent tools.

The root `apm.yml` declares `copilot` and `opencode` as targets and currently has no APM or MCP dependencies. The `copilot` target covers GitHub Copilot in both the CLI and IDE, including VS Code. Add dependencies to the manifest and run `apm install` from the repository root to install them for the selected targets; use `apm --help` to see the available commands.

## Common Commands

```sh
# Install/synchronize project dependencies
uv sync

# Run the available project tasks
poe fmt
poe pre-commit

# Run tests and tools that are not currently Poe tasks
uv run pytest
uv run mypy src
uv run pyright
```
