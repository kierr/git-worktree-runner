#!/bin/sh
# Example setup script for gwr configuration
# Customize this for your project

set -e

echo "🔧 Configuring gwr for this repository..."

# Worktree settings
git config --local gwr.worktrees.prefix ""
git config --local gwr.defaultBranch "auto"

# Editor (change to your preference: cursor, vscode, zed)
# git config --local gwr.editor.default cursor

# File copying (add patterns for your project)
# git config --local --add gwr.copy.include "**/.env.example"
# git config --local --add gwr.copy.include "**/CLAUDE.md"

# Hooks (customize for your build system)
# git config --local --add gwr.hook.postCreate "npm install"
# git config --local --add gwr.hook.postCreate "npm run build"

# Or for pnpm projects:
# git config --local --add gwr.hook.postCreate "pnpm install"
# git config --local --add gwr.hook.postCreate "pnpm run build"

# Or for other tools:
# git config --local --add gwr.hook.postCreate "bundle install"
# git config --local --add gwr.hook.postCreate "cargo build"

echo "✅ gwr configured!"
echo ""
echo "View config with: git config --local --list | grep gwr"
echo "Create a worktree with: gwr new my-feature"
