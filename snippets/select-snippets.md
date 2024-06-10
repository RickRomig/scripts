# select snippets
### select menu
```bash
# shellcheck disable=SC2034
# Ignores Shellcheck warning because 'opt' isn't used.
options=("Option 1" "Option 2" "Option 3" "Option 4" "Quit")
COLUMNS=40		# forces menu to display one column (60, 80)
PS3="Option: "
select opt in "${options[@]}"; do
	case "$REPLY" in
		1 ) echo "Option 1"; break ;;
		2 ) echo "Option 2"; break ;;
		3 ) echo "Option 3"; break ;;
		4 ) echo "Option 4"; break ;;
		* ) echo "Invalid option"
	esac
done
```
### select Yes/No menu
```bash
# shellcheck disable=SC2034
# Ignores Shellcheck warning because 'opt' isn't used.
echo "Do you want to do something?"
PS3="Choice: "
select opt in "Yes" "No"; do
	case "$REPLY" in
		1 ) echo "Do it." ;;
		2 ) echo "Don't do it." ;;
		* ) echo "Invalid choices. Choose 1 for yes, 2 for no."
	esac
done
```
### if-elif-else option to case
```bash
# shellcheck disable=SC2034
# Ignores Shellcheck warning because 'repo' isn't used.
COLUMNS=40
PS3="Choose a repository to clone: "
readonly repos=( scripts configs i3debian deb12wm-scripts deb12wm-dotfiles gitea-server openboxdebian fnloc fnloc-win homepage )
select repo in "${repos[@]}" "Exit"; do
	if (( REPLY == 1 + ${#repos[@]} )); then
		printf "Exiting. No repository selected or cloned.\n"
		break
	elif (( REPLY > 0 && REPLY <= ${#repos[@]} )); then
    index=$((( REPLY - 1 )))
    printf "Cloning the %s repository...\n" "${repos[index]}"
		clone_repo "${repos[index]}"
		break
	else
		printf "Invalid option. Choose 1 - %d\n" "${#repos[@]}"
	fi
done
```
