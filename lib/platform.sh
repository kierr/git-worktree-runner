#!/usr/bin/env bash
# Platform-specific utilities

# Detect operating system
# Returns: darwin, linux, or windows
detect_os() {
	case "$OSTYPE" in
	darwin*)
		echo "darwin"
		;;
	linux*)
		echo "linux"
		;;
	msys* | cygwin* | win32*)
		echo "windows"
		;;
	*)
		# Fallback to uname
		case "$(uname -s 2>/dev/null)" in
		Darwin)
			echo "darwin"
			;;
		Linux)
			echo "linux"
			;;
		MINGW* | MSYS* | CYGWIN*)
			echo "windows"
			;;
		*)
			echo "unknown"
			;;
		esac
		;;
	esac
}

# Open a directory in the system's GUI file browser
# Usage: open_in_gui path
open_in_gui() {
	local path="$1"
	local os

	os=$(detect_os)

	case "$os" in
	darwin)
		open "$path" 2>/dev/null || true
		;;
	linux)
		# Try common Linux file managers
		if command -v xdg-open >/dev/null 2>&1; then
			xdg-open "$path" >/dev/null 2>&1 || true
		elif command -v gnome-open >/dev/null 2>&1; then
			gnome-open "$path" >/dev/null 2>&1 || true
		fi
		;;
	windows)
		if command -v cygpath >/dev/null 2>&1; then
			cmd.exe /c start "" "$(cygpath -w "$path")" 2>/dev/null || true
		else
			cmd.exe /c start "" "$path" 2>/dev/null || true
		fi
		;;
	*)
		log_warn "Cannot open GUI on unknown OS"
		return 1
		;;
	esac
}

# Spawn a new terminal window/tab in a directory
# Usage: spawn_terminal_in path title [command]
# Note: Best-effort implementation, may not work on all systems
spawn_terminal_in() {
	local path="$1"
	local title="$2"
	local cmd="${3-}"
	local os

	os=$(detect_os)

	case "$os" in
	darwin)
		# Try iTerm2 first, then Terminal.app
		if osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null | grep -q "iTerm"; then
			osascript <<-EOF 2>/dev/null || true
				tell application "iTerm"
					tell current window
						create tab with default profile
						tell current session
							write text "cd $(printf '%q' "$path")"
							set name to "$(printf '%s' "$title" | sed 's/"/\\"/g')"
							$(if [ -n "$cmd" ]; then echo "write text $(printf '%q' "$cmd")"; fi)
						end tell
					end tell
				end tell
			EOF
		else
			osascript <<-EOF 2>/dev/null || true
				tell application "Terminal"
					do script "cd $(printf '%q' "$path")$([ -n "$cmd" ] && echo "; $(printf '%q' "$cmd")")"
					set custom title of front window to "$(printf '%s' "$title" | sed 's/"/\\"/g')"
				end tell
			EOF
		fi
		;;
	linux)
		# Try common terminal emulators
		if command -v gnome-terminal >/dev/null 2>&1; then
			local shell_cmd='exec $SHELL'
			if [ -n "$cmd" ]; then
				shell_cmd="$(printf '%q' "$cmd"); $shell_cmd"
			fi
			gnome-terminal --working-directory="$path" --title="$title" -- sh -c "$shell_cmd" 2>/dev/null || true
		elif command -v konsole >/dev/null 2>&1; then
			local shell_cmd='exec $SHELL'
			if [ -n "$cmd" ]; then
				shell_cmd="$(printf '%q' "$cmd"); $shell_cmd"
			fi
			konsole --workdir "$path" -p "tabtitle=$title" -e sh -c "$shell_cmd" 2>/dev/null || true
		elif command -v xterm >/dev/null 2>&1; then
			local shell_cmd='exec $SHELL'
			if [ -n "$cmd" ]; then
				shell_cmd="$(printf '%q' "$cmd") && $shell_cmd"
			fi
			xterm -T "$title" -e "cd $(printf '%q' "$path") && $shell_cmd" 2>/dev/null || true
		else
			log_warn "No supported terminal emulator found"
			return 1
		fi
		;;
	windows)
		# Try Windows Terminal, then fallback to cmd
		if command -v wt >/dev/null 2>&1; then
			if [ -n "$cmd" ]; then
				wt -d "$path" cmd.exe /c "$(printf '%s' "$cmd" | sed 's/\"/\\"/g')" 2>/dev/null || true
			else
				wt -d "$path" 2>/dev/null || true
			fi
		else
			if [ -n "$cmd" ]; then
				cmd.exe /c start "$title" cmd.exe /k "cd /d $(cygpath -w "$path" 2>/dev/null || echo "$path") && $(printf '%s' "$cmd" | sed 's/\"/\\"/g')" 2>/dev/null || true
			else
				cmd.exe /c start "$title" cmd.exe /k "cd /d $(cygpath -w "$path" 2>/dev/null || echo "$path")" 2>/dev/null || true
			fi
		fi
		;;
	*)
		log_warn "Cannot spawn terminal on unknown OS"
		return 1
		;;
	esac
}
