#!/bin/bash
# Bash completion for gwr

_gwr_completion() {
	local cur prev words cword
	_init_completion || return

	local cmd="${words[1]}"

	# Complete commands on first argument
	if [ "$cword" -eq 1 ]; then
		COMPREPLY=($(compgen -W "new go editor ai rm ls list clean doctor adapter config help version" -- "$cur"))
		return 0
	fi

	# Commands that take branch names or '1' for main repo
	case "$cmd" in
	go | editor | ai | rm)
		if [ "$cword" -eq 2 ]; then
			# Complete with branch names from existing worktrees
			local branches all_options
			branches=$(gwr list --porcelain 2>/dev/null | cut -f2 | grep -v '^$' | sort -u || true)
			all_options="1 $branches"
			COMPREPLY=($(compgen -W "$all_options" -- "$cur"))
		elif [[ $cur == -* ]]; then
			case "$cmd" in
			rm)
				COMPREPLY=($(compgen -W "--delete-branch --force --yes" -- "$cur"))
				;;
			esac
		fi
		;;
	new)
		# Complete flags
		if [[ $cur == -* ]]; then
			COMPREPLY=($(compgen -W "--id --from --track --no-copy --no-fetch --force --name --yes" -- "$cur"))
		elif [ "$prev" = "--track" ]; then
			COMPREPLY=($(compgen -W "auto remote local none" -- "$cur"))
		fi
		;;
	config)
		if [ "$cword" -eq 2 ]; then
			COMPREPLY=($(compgen -W "get set unset" -- "$cur"))
		elif [ "$cword" -eq 3 ]; then
			COMPREPLY=($(compgen -W "gwr.worktrees.dir gwr.worktrees.prefix gwr.defaultBranch gwr.editor.default gwr.ai.default gwr.copy.include gwr.copy.exclude gwr.hook.postCreate gwr.hook.postRemove" -- "$cur"))
		fi
		;;
	esac
}

complete -F _gwr_completion gwr
