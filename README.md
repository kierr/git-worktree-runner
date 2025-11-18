# gwr - Git Worktree Runner

> A portable, cross-platform CLI for managing git worktrees with ease

![4 AI agents working in parallel across different worktrees](docs/assets/demo-parallel.png)

## What are git worktrees?

**ELI5:** Normally, you can only work on one git branch at a time in a folder. Want to fix a bug while working on a feature? You have to stash changes, switch branches, then switch back. Git worktrees let you have multiple branches checked out at once in different folders - like having multiple copies of your project, each on a different branch.

**The Problem:** Everyone's using git worktrees wrong (or not at all):

- 🔄 Constantly stashing/switching branches disrupts flow
- 🤹 Running tests on main while working on features requires manual copying
- 👥 Reviewing PRs means stopping current work
- 🤖 **Parallel AI agents on different branches?** Nearly impossible without worktrees

**Why people sleep on worktrees:** The DX is terrible. `git worktree add ../my-project-feature feature` is verbose, manual, and error-prone.

**Enter gwr:** Simple commands, AI tool integration, automatic setup, and built for modern parallel development workflows.

## Quick Start

**Install (30 seconds):**

```bash
git clone https://github.com/coderabbitai/git-worktree-runner.git
cd git-worktree-runner
sudo ln -s "$(pwd)/bin/gwr" /usr/local/bin/gwr
```

**Use it (3 commands):**

```bash
cd ~/your-repo                              # Navigate to git repo
gwr config set gwr.editor.default cursor    # One-time setup
gwr config set gwr.ai.default claude        # One-time setup

# Daily workflow
gwr new my-feature                          # Create worktree
gwr editor my-feature                       # Open in editor
gwr ai my-feature                           # Start AI tool
gwr rm my-feature                           # Remove when done
```

## Why gwr?

While `git worktree` is powerful, it's verbose and manual. `gwr` adds quality-of-life features for modern development:

| Task              | With `git worktree`                        | With `gwr`                           |
| ----------------- | ------------------------------------------ | ------------------------------------ |
| Create worktree   | `git worktree add ../repo-feature feature` | `gwr new feature`                    |
| Open in editor    | `cd ../repo-feature && cursor .`           | `gwr editor feature`                 |
| Start AI tool     | `cd ../repo-feature && aider`              | `gwr ai feature`                     |
| Copy config files | Manual copy/paste                          | Auto-copy via `gwr.copy.include`     |
| Run build steps   | Manual `npm install && npm run build`      | Auto-run via `gwr.hook.postCreate`   |
| List worktrees    | `git worktree list` (shows paths)          | `gwr list` (shows branches + status) |
| Clean up          | `git worktree remove ../repo-feature`      | `gwr rm feature`                     |

**TL;DR:** `gwr` wraps `git worktree` with quality-of-life features for modern development workflows (AI tools, editors, automation).

## Features

- 🚀 **Simple commands** - Create and manage worktrees with intuitive CLI
- 📁 **Repository-scoped** - Each repo has independent worktrees
- 🔧 **Configuration over flags** - Set defaults once, use simple commands
- 🎨 **Editor integration** - Open worktrees in Cursor, VS Code, Zed, and more
- 🤖 **AI tool support** - Launch Aider, Claude Code, or other AI coding tools
- 📋 **Smart file copying** - Selectively copy configs/env files to new worktrees
- 🪝 **Hooks system** - Run custom commands after create/remove
- 🌍 **Cross-platform** - Works on macOS, Linux, and Windows (Git Bash)
- 🎯 **Shell completions** - Tab completion for Bash, Zsh, and Fish

## Quick Start

```bash
# Navigate to your git repo
cd ~/GitHub/my-project

# One-time setup (per repository)
gwr config set gwr.editor.default cursor
gwr config set gwr.ai.default claude

# Daily workflow
gwr new my-feature          # Create worktree folder: my-feature
gwr editor my-feature       # Open in cursor
gwr ai my-feature           # Start claude

# Navigate to worktree
cd "$(gwr go my-feature)"

# List all worktrees
gwr list

# Remove when done
gwr rm my-feature
```

## Requirements

- **Git** 2.5+ (for `git worktree` support)
- **Bash** 3.2+ (macOS ships 3.2; 4.0+ recommended for advanced features)

## Installation

### Quick Install (macOS/Linux)

```bash
# Clone the repository
git clone https://github.com/coderabbitai/git-worktree-runner.git
cd git-worktree-runner

# Add to PATH (choose one)
# Option 1: Symlink to /usr/local/bin
sudo ln -s "$(pwd)/bin/gwr" /usr/local/bin/gwr

# Option 2: Add to your shell profile
echo 'export PATH="$PATH:'$(pwd)'/bin"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

### Shell Completions (Optional)

**Bash** (requires `bash-completion` v2):

```bash
# Install bash-completion first (if not already installed)
# macOS:
brew install bash-completion@2

# Ubuntu/Debian:
sudo apt install bash-completion

# Then enable gwr completions:
echo 'source /path/to/git-worktree-runner/completions/gwr.bash' >> ~/.bashrc
source ~/.bashrc
```

**Zsh:**

```bash
echo 'source /path/to/git-worktree-runner/completions/_gwr' >> ~/.zshrc
```

**Fish:**

```bash
ln -s /path/to/git-worktree-runner/completions/gwr.fish ~/.config/fish/completions/
```

## Commands

Commands accept branch names to identify worktrees. Use `1` to reference the main repo.
Run `gwr help` for full documentation.

### `gwr new <branch> [options]`

Create a new git worktree. Folder is named after the branch.

```bash
gwr new my-feature                              # Creates folder: my-feature
gwr new hotfix --from v1.2.3                    # Create from specific ref
gwr new feature/auth                            # Creates folder: feature-auth
gwr new feature-auth --name backend --force     # Same branch, custom name
gwr new my-feature --name descriptive-variant   # Optional: custom name without --force
```

**Options:**

- `--from <ref>`: Create from specific ref
- `--track <mode>`: Tracking mode (auto|remote|local|none)
- `--no-copy`: Skip file copying
- `--no-fetch`: Skip git fetch
- `--force`: Allow same branch in multiple worktrees (**requires --name**)
- `--name <suffix>`: Custom folder name suffix (optional, required with --force)
- `--yes`: Non-interactive mode

### `gwr editor <branch> [--editor <name>]`

Open worktree in editor (uses `gwr.editor.default` or `--editor` flag).

```bash
gwr editor my-feature                    # Uses configured editor
gwr editor my-feature --editor vscode    # Override with vscode
```

### `gwr ai <branch> [--ai <name>] [-- args...]`

Start AI coding tool (uses `gwr.ai.default` or `--ai` flag).

```bash
gwr ai my-feature                      # Uses configured AI tool
gwr ai my-feature --ai aider          # Override with aider
gwr ai my-feature -- --model gpt-4    # Pass arguments to tool
gwr ai 1                              # Use AI in main repo
```

### `gwr go <branch>`

Print worktree path for shell navigation.

```bash
cd "$(gwr go my-feature)"    # Navigate by branch name
cd "$(gwr go 1)"             # Navigate to main repo
```

### `gwr rm <branch>... [options]`

Remove worktree(s) by branch name.

```bash
gwr rm my-feature                              # Remove one
gwr rm feature-a feature-b                     # Remove multiple
gwr rm my-feature --delete-branch --force      # Delete branch and force
```

**Options:** `--delete-branch`, `--force`, `--yes`

### `gwr list [--porcelain]`

List all worktrees. Use `--porcelain` for machine-readable output.

### `gwr config {get|set|add|unset} <key> [value] [--global]`

Manage configuration via git config.

```bash
gwr config set gwr.editor.default cursor       # Set locally
gwr config set gwr.ai.default claude --global  # Set globally
gwr config get gwr.editor.default              # Get value
```

### Other Commands

- `gwr doctor` - Health check (verify git, editors, AI tools)
- `gwr adapter` - List available editor & AI adapters
- `gwr clean` - Remove stale worktrees
- `gwr version` - Show version

## Configuration

All configuration is stored via `git config`, making it easy to manage per-repository or globally.

### Worktree Settings

```bash
# Base directory for worktrees
# Default: <repo-name>-worktrees (sibling to repo)
# Supports: absolute paths, repo-relative paths, tilde expansion
gwr.worktrees.dir = <path>

# Examples:
# Absolute path
gwr.worktrees.dir = /Users/you/all-worktrees/my-project

# Repo-relative (inside repository - requires .gitignore entry)
gwr.worktrees.dir = .worktrees

# Home directory (tilde expansion)
gwr.worktrees.dir = ~/worktrees/my-project

# Folder prefix (default: "")
gwr.worktrees.prefix = dev-

# Default branch (default: auto-detect)
gwr.defaultBranch = main
```

> [!IMPORTANT]
> If storing worktrees inside the repository, add the directory to `.gitignore`.

```bash
echo "/.worktrees/" >> .gitignore
```

### Editor Settings

```bash
# Default editor: cursor, vscode, zed, or none
gwr.editor.default = cursor
```

**Setup editors:**

- **Cursor**: Install from [cursor.com](https://cursor.com), enable shell command
- **VS Code**: Install from [code.visualstudio.com](https://code.visualstudio.com), enable `code` command
- **Zed**: Install from [zed.dev](https://zed.dev), `zed` command available automatically

### AI Tool Settings

```bash
# Default AI tool: none (or aider, claude, codex, cursor, continue)
gwr.ai.default = none
```

**Supported AI Tools:**

| Tool                                              | Install                                           | Use Case                             | Set as Default                           |
| ------------------------------------------------- | ------------------------------------------------- | ------------------------------------ | ---------------------------------------- |
| **[Aider](https://aider.chat)**                   | `pip install aider-chat`                          | Pair programming, edit files with AI | `gwr config set gwr.ai.default aider`    |
| **[Claude Code](https://claude.com/claude-code)** | Install from claude.com                           | Terminal-native coding agent         | `gwr config set gwr.ai.default claude`   |
| **[Codex CLI](https://github.com/openai/codex)**  | `npm install -g @openai/codex`                    | OpenAI coding assistant              | `gwr config set gwr.ai.default codex`    |
| **[Cursor](https://cursor.com)**                  | Install from cursor.com                           | AI-powered editor with CLI agent     | `gwr config set gwr.ai.default cursor`   |
| **[Continue](https://continue.dev)**              | See [docs](https://docs.continue.dev/cli/install) | Open-source coding agent             | `gwr config set gwr.ai.default continue` |

**Examples:**

```bash
# Set default AI tool for this repo
gwr config set gwr.ai.default claude

# Or set globally for all repos
gwr config set gwr.ai.default claude --global

# Then just use gwr ai
gwr ai my-feature

# Pass arguments to the tool
gwr ai my-feature -- --plan "refactor auth"
```

### File Copying

Copy files to new worktrees using glob patterns:

```bash
# Add patterns to copy (multi-valued)
gwr config add gwr.copy.include "**/.env.example"
gwr config add gwr.copy.include "**/CLAUDE.md"
gwr config add gwr.copy.include "*.config.js"

# Exclude patterns (multi-valued)
gwr config add gwr.copy.exclude "**/.env"
gwr config add gwr.copy.exclude "**/secrets.*"
```

> [!WARNING]
> Be careful not to copy sensitive files. Use `.env.example` instead of `.env`.

### Hooks

Run custom commands after worktree operations:

```bash
# Post-create hooks (multi-valued, run in order)
gwr config add gwr.hook.postCreate "npm install"
gwr config add gwr.hook.postCreate "npm run build"

# Post-remove hooks
gwr config add gwr.hook.postRemove "echo 'Cleaned up!'"
```

**Environment variables available in hooks:**

- `REPO_ROOT` - Repository root path
- `WORKTREE_PATH` - New worktree path
- `BRANCH` - Branch name

**Examples for different build tools:**

```bash
# Node.js (npm)
gwr config add gwr.hook.postCreate "npm install"

# Node.js (pnpm)
gwr config add gwr.hook.postCreate "pnpm install"

# Python
gwr config add gwr.hook.postCreate "pip install -r requirements.txt"

# Ruby
gwr config add gwr.hook.postCreate "bundle install"

# Rust
gwr config add gwr.hook.postCreate "cargo build"
```

## Configuration Examples

### Minimal Setup (Just Basics)

```bash
gwr config set gwr.worktrees.prefix "wt-"
gwr config set gwr.defaultBranch "main"
```

### Full-Featured Setup (Node.js Project)

```bash
# Worktree settings
gwr config set gwr.worktrees.prefix "wt-"

# Editor
gwr config set gwr.editor.default cursor

# Copy environment templates
gwr config add gwr.copy.include "**/.env.example"
gwr config add gwr.copy.include "**/.env.development"
gwr config add gwr.copy.exclude "**/.env.local"

# Build hooks
gwr config add gwr.hook.postCreate "pnpm install"
gwr config add gwr.hook.postCreate "pnpm run build"
```

### Global Defaults

```bash
# Set global preferences
gwr config set gwr.editor.default cursor --global
gwr config set gwr.ai.default claude --global
```

## Advanced Usage

### How It Works: Repository Scoping

**gwr is repository-scoped** - each git repository has its own independent set of worktrees:

- Run `gwr` commands from within any git repository
- Worktree folders are named after their branch names
- Each repo manages its own worktrees independently
- Switch repos with `cd`, then run `gwr` commands for that repo

### Working with Multiple Branches

```bash
# Terminal 1: Work on feature
gwr new feature-a
gwr editor feature-a

# Terminal 2: Review PR
gwr new pr/123
gwr editor pr/123

# Terminal 3: Navigate to main branch (repo root)
cd "$(gwr go 1)"  # Special ID '1' = main repo
```

### Working with Multiple Repositories

Each repository has its own independent set of worktrees. Switch repos with `cd`:

```bash
# Frontend repo
cd ~/GitHub/frontend
gwr list
# BRANCH          PATH
# main [main]     ~/GitHub/frontend
# auth-feature    ~/GitHub/frontend-worktrees/auth-feature
# nav-redesign    ~/GitHub/frontend-worktrees/nav-redesign

gwr editor auth-feature      # Open frontend auth work
gwr ai nav-redesign          # AI on frontend nav work

# Backend repo (separate worktrees)
cd ~/GitHub/backend
gwr list
# BRANCH          PATH
# main [main]     ~/GitHub/backend
# api-auth        ~/GitHub/backend-worktrees/api-auth
# websockets      ~/GitHub/backend-worktrees/websockets

gwr editor api-auth          # Open backend auth work
gwr ai websockets            # AI on backend websockets

# Switch back to frontend
cd ~/GitHub/frontend
gwr editor auth-feature      # Opens frontend auth
```

**Key point:** Each repository has its own worktrees. Use branch names to identify worktrees.

### Custom Workflows with Hooks

Create a `.gwr-setup.sh` in your repo:

```bash
#!/bin/sh
# .gwr-setup.sh - Project-specific gwr configuration

gwr config set gwr.worktrees.prefix "dev-"
gwr config set gwr.editor.default cursor

# Copy configs
gwr config add gwr.copy.include ".env.example"
gwr config add gwr.copy.include "docker-compose.yml"

# Setup hooks
gwr config add gwr.hook.postCreate "docker-compose up -d db"
gwr config add gwr.hook.postCreate "npm install"
gwr config add gwr.hook.postCreate "npm run db:migrate"
```

Then run: `sh .gwr-setup.sh`

### Non-Interactive Automation

Perfect for CI/CD or scripts:

```bash
# Create worktree without prompts
gwr new ci-test --yes --no-copy

# Remove without confirmation
gwr rm ci-test --yes --delete-branch
```

### Multiple Worktrees on Same Branch

> [!TIP]
> Git normally prevents checking out the same branch in multiple worktrees to avoid conflicts. `gwr` supports bypassing this safety check with `--force` and `--name` flags.

**Use cases:**

- Splitting work across multiple AI agents on one feature
- Testing same branch in different environments/configs
- Running parallel CI/build processes
- Debugging without disrupting main worktree

**Risks:**

- Concurrent edits in multiple worktrees can cause conflicts
- Easy to lose work if not careful
- Git's safety check exists for good reason

**Using `--force` with `--name` (required):**

```bash
# Create multiple worktrees for same branch with descriptive names
gwr new feature-auth                          # Main worktree: feature-auth/
gwr new feature-auth --force --name backend   # Creates: feature-auth-backend/
gwr new feature-auth --force --name frontend  # Creates: feature-auth-frontend/
gwr new feature-auth --force --name tests     # Creates: feature-auth-tests/

# All worktrees are on the same 'feature-auth' branch
# The --name flag is required with --force to distinguish worktrees
```

**Example: Parallel AI development on one feature:**

```bash
# Terminal 1: Backend work
gwr new feature-auth --force --name backend
gwr ai feature-auth-backend -- --message "Implement API endpoints"

# Terminal 2: Frontend work
gwr new feature-auth --force --name frontend
gwr ai feature-auth-frontend -- --message "Build UI components"

# Terminal 3: Tests
gwr new feature-auth --force --name tests
gwr ai feature-auth-tests -- --message "Write integration tests"

# All agents commit to the same feature-auth branch
```

**Best practices when using --force:**

- Always provide a descriptive `--name` (backend, frontend, tests, ci, etc.)
- Only edit files in one worktree at a time
- Commit/stash changes before switching worktrees
- Ideal for parallel AI agents working on different parts of one feature
- Use `gwr list` to see all worktrees and their branches

## Troubleshooting

### Worktree Creation Fails

```bash
# Ensure you've fetched latest refs
git fetch origin

# Check if branch already exists
git branch -a | grep your-branch

# Manually specify tracking mode
gwr new test --track remote
```

### Editor Not Opening

```bash
# Verify editor command is available
command -v cursor  # or: code, zed

# Check configuration
gwr config get gwr.editor.default

# Try opening again
gwr editor 2
```

### File Copying Issues

```bash
# Check your patterns
gwr config get gwr.copy.include

# Test patterns with find
cd /path/to/repo
find . -path "**/.env.example"
```

## Platform Support

- ✅ **macOS** - Full support (Ventura+)
- ✅ **Linux** - Full support (Ubuntu, Fedora, Arch, etc.)
- ✅ **Windows** - Via Git Bash or WSL

**Platform-specific notes:**

- **macOS**: GUI opening uses `open`, terminal spawning uses iTerm2/Terminal.app
- **Linux**: GUI opening uses `xdg-open`, terminal spawning uses gnome-terminal/konsole
- **Windows**: GUI opening uses `start`, requires Git Bash or WSL

## Architecture

```log
git-worktree-runner/
├── bin/gwr              # Main executable
├── lib/                 # Core libraries
│   ├── core.sh         # Git worktree operations
│   ├── config.sh       # Configuration management
│   ├── platform.sh     # OS-specific code
│   ├── ui.sh           # User interface
│   ├── copy.sh         # File copying
│   └── hooks.sh        # Hook execution
├── adapters/           # Editor & AI tool plugins
│   ├── editor/
│   └── ai/
├── completions/        # Shell completions
└── templates/          # Example configs
```

## Reliability & Testing Status

**Current Status:** Production-ready for daily use

**Tested Platforms:**

- ✅ **macOS** - Ventura (13.x), Sonoma (14.x), Sequoia (15.x)
- ✅ **Linux** - Ubuntu 22.04/24.04, Fedora 39+, Arch Linux
- ⚠️ **Windows** - Git Bash (tested), WSL2 (tested), PowerShell (not supported)

**Git Versions:**

- ✅ Git 2.25+ (recommended)
- ✅ Git 2.22+ (full support)
- ⚠️ Git 2.5-2.21 (basic support, some features limited)

**Known Limitations:**

- Shell completions require bash-completion v2+ for Bash
- Some AI adapters require recent tool versions (see adapter docs)
- Windows native (non-WSL) support is experimental

**Testing Approach:**

- Core functionality tested across macOS, Linux, WSL2
- Manual testing with Cursor, VS Code, Aider, Claude Code
- Used in production for parallel agent workflows
- Community testing appreciated - please report issues!

**Experimental Features:**

- `--force` flag for same-branch worktrees (use with caution)
- Windows PowerShell support (use Git Bash or WSL instead)

## Contributing

Contributions welcome! Areas where help is appreciated:

- 🎨 **New editor adapters** - JetBrains IDEs, Neovim, etc.
- 🤖 **New AI tool adapters** - Continue.dev, Codeium, etc.
- 🐛 **Bug reports** - Platform-specific issues
- 📚 **Documentation** - Tutorials, examples, use cases
- ✨ **Features** - Propose enhancements via issues

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Related Projects

- [git-worktree](https://git-scm.com/docs/git-worktree) - Official git documentation
- [Aider](https://aider.chat) - AI pair programming in your terminal
- [Cursor](https://cursor.com) - AI-powered code editor

## License

Copyright 2025 CodeRabbit

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

- <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Acknowledgments

Built to streamline parallel development workflows with git worktrees. Inspired by the need for simple, configurable worktree management across different development environments.

## Happy coding with worktrees! 🚀

For questions or issues, please [open an issue](https://github.com/coderabbitai/git-worktree-runner/issues).
