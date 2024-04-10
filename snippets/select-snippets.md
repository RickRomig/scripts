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
