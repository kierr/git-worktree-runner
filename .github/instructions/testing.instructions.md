---
applyTo: bin/gwr, lib/**/*.sh, adapters/**/*.sh
---

# Testing Instructions

Run after core or adapter changes; all manual (no automated tests).

```bash
# Basic create/remove
./bin/gwr new test-feature           # folder test-feature
./bin/gwr rm test-feature            # removed

# Branch sanitization
./bin/gwr new feature/auth           # folder feature-auth

# Remote branch (if exists)
./bin/gwr new existing-remote-branch # checks out tracking branch

# Local existing branch
./bin/gwr new existing-local-branch  # reuses local branch

# New branch creation
./bin/gwr new brand-new-feature      # creates branch + worktree

# Force multiple worktrees same branch
./bin/gwr new test-feature --force --name backend   # test-feature-backend

# Editor + AI adapters
./bin/gwr config set gwr.editor.default cursor
./bin/gwr open test-feature
./bin/gwr config set gwr.ai.default claude
./bin/gwr ai test-feature

# Listing
./bin/gwr list                       # human table
./bin/gwr list --porcelain           # path\tbranch\tstatus

# Navigation
cd "$(./bin/gwr go 1)"               # repo root
cd "$(./bin/gwr go test-feature)"    # worktree path

# Config commands
./bin/gwr config set gwr.editor.default cursor
./bin/gwr config get gwr.editor.default
./bin/gwr config set gwr.editor.default vscode --global
./bin/gwr config unset gwr.editor.default

# Copy patterns
git config --add gwr.copy.include "**/.env.example"
git config --add gwr.copy.exclude "**/.env"
./bin/gwr new test-copy              # copies example, not real env

# Hooks
git config --add gwr.hook.postCreate "echo 'Created!' > /tmp/gwr-test"
./bin/gwr new test-hooks             # /tmp/gwr-test exists
git config --add gwr.hook.postRemove "echo 'Removed!' > /tmp/gwr-removed"
./bin/gwr rm test-hooks              # /tmp/gwr-removed exists
```

## Installation & Environment Verification

```bash
git --version
./bin/gwr doctor      # checks repo, adapters, platform
./bin/gwr adapter     # lists editors + AI tools
```

## Adapter Sourcing Checks

```bash
bash -c 'source adapters/editor/cursor.sh && editor_can_open && echo OK'
bash -c 'source adapters/ai/claude.sh && ai_can_start && echo OK'
```

## Debugging Toolkit

```bash
bash -x ./bin/gwr new test-feature   # global trace
set -x; create_worktree ...; set +x  # scoped trace inside function
declare -f resolve_target            # confirm function loaded
echo "DEBUG worktree_path=$worktree_path" >&2  # variable inspection
```

## Success Criteria

- All commands exit 0 (except intentional failures) and produce expected side-effects.
- No unquoted path errors; spaces handled.
- Hooks run only once per creation/removal.
- `list --porcelain` stable for scripting.

## When Adding Features

- Extend this matrix minimally (keep concise).
- Prefer adding under relevant section (e.g. new flag under create/remove).
