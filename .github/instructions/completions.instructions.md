---
applyTo: completions/gwr.bash, completions/_gwr, completions/gwr.fish
---

# Completions Instructions

## Overview

Shell completions provide tab-completion for `gwr` commands, flags, branches, and adapter names across Bash, Zsh, and Fish shells.

## When to Update Completions

**Always update all three completion files** when:

- Adding new commands (e.g., `gwr new-command`)
- Adding new flags to existing commands (e.g., `--new-flag`)
- Adding editor or AI adapters (completion must list available adapters)
- Changing command names or flag names

## File Responsibilities

- **`completions/gwr.bash`** - Bash completion (requires bash-completion v2+)
- **`completions/_gwr`** - Zsh completion (uses Zsh completion system)
- **`completions/gwr.fish`** - Fish shell completion

## Implementation Pattern

Each completion file implements:

1. **Command completion** - Top-level commands (`new`, `rm`, `go`, `ai`, `list`, etc.)
2. **Flag completion** - Command-specific flags (e.g., `--from`, `--force`, `--editor`)
3. **Branch completion** - Dynamic completion of existing worktree branches (via `gwr list --porcelain`)
4. **Adapter completion** - Editor names (`cursor`, `vscode`, `zed`) and AI tool names (`aider`, `claude`, `codex`)

## Testing Completions

**Manual testing** (no automated tests):

```bash
# Bash - source the completion file
source completions/gwr.bash
gwr <TAB>                    # Should show commands
gwr new <TAB>                # Should show flags
gwr open <TAB>               # Should show branches
gwr open --editor <TAB>      # Should show editor names

# Zsh - fpath must include completions directory
fpath=(completions $fpath)
autoload -U compinit && compinit
gwr <TAB>

# Fish - symlink to ~/.config/fish/completions/
ln -s "$(pwd)/completions/gwr.fish" ~/.config/fish/completions/
gwr <TAB>
```

## Branch Completion Logic

All three completions dynamically fetch current worktree branches:

- Parse output of `gwr list --porcelain` (tab-separated format: `path\tbranch\tstatus`)
- Extract branch column (second field: `cut -f2`)
- Add special ID `1` for main repository
- Sort and deduplicate branches (`sort -u`)
- Filter out empty lines (`grep -v '^$'`)

**Note**: This ensures completions only show branches that have actual worktrees, not all branches in the repository.

## Adapter Name Updates

When adding an editor or AI adapter:

**Bash** (`completions/gwr.bash`):

- Update `_gwr_editors` array or case statement
- Update flag completion for `--editor` in `open` command

**Zsh** (`completions/_gwr`):

- Update `_arguments` completion specs for `--editor` or `--ai`
- Use `_values` or `_alternative` for adapter names

**Fish** (`completions/gwr.fish`):

- Update `complete -c gwr` lines for editor/AI flags
- List adapter names explicitly or parse from `gwr adapter` output

## Keep in Sync

The three completion files must stay synchronized:

- Same commands supported
- Same flags for each command
- Same adapter names
- Same branch completion behavior

## Examples

**Adding a new command `gwr status`**:

1. Add `status` to main command list in all three files
2. Add flag completion if the command has flags
3. Test tab completion works

**Adding a new editor `sublime`**:

1. Create `adapters/editor/sublime.sh` with contract functions
2. Add `sublime` to editor list in all three completion files
3. Update help text in `bin/gwr` (`cmd_help` function)
4. Update README with installation instructions
5. Test `gwr open --editor s<TAB>` completes to `sublime`

## Common Pitfalls

- **Forgetting to update all three files** - Always update Bash, Zsh, AND Fish
- **Hardcoding adapter names** - Keep adapter lists in sync with actual files in `adapters/{editor,ai}/`
- **Not testing** - Source/reload completions and test with `<TAB>` key
- **Case sensitivity** - Command and flag names must match exactly (case-sensitive)

## Bash-Specific Notes

- Requires `bash-completion` v2+ package
- Use `COMPREPLY` array to return completions
- Use `compgen` to filter based on current word (`$cur`)
- Check `$COMP_CWORD` for argument position

## Zsh-Specific Notes

- Uses `_arguments` completion framework
- Supports more sophisticated completion logic (descriptions, grouping)
- Use `_describe` for simple lists, `_arguments` for complex commands

## Fish-Specific Notes

- Uses declarative `complete -c gwr` syntax
- Conditions can check previous arguments with `__fish_seen_subcommand_from`
- Can call external commands for dynamic completion
