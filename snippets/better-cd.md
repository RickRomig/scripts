# better-cd

Set up keybinding Ctrl+h to return to home directory.

Add to .bashrc
fzf (fuzzy finder) must be installed.

```bash
cd() {
	[[ $# -eq 0 ]] && return
	builtin cd "$@"
}

bettercd() {
	cd "$1"
	if [[ -z "$1"]]; then
		selection="$(ls -a | fzf --height 40% --reverse)"
		if [[ -d "$selection" ]]; then
			cd "$selection"
		elif [[ -f "$selection" ]]; then
			micro "$selection"
		fi
	fi
}

alias cd="bettercd"
```
