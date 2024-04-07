# Args

### Check arguments to see if file exists
```bash
if [[ "$#" -eq 0 ]]; then
	echo "Error: No argument passed" >&2; usage; exit 1
elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
	usage; exit
elif [[ -f "$1" ]]; then
	echo "Error: $1 already exists." >&2; usage; exit
else
	filename="$1"
fi
```
### Check arguments - file not found
```bash
if [[ "$#" -eq 0 ]]; then
	echo "Error: No argument passed." >&2; usage; exit 1
elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
	usage; exit
elif [[ ! f "$1"  ]]; then
	echo "Error: $1 not found." >&2; usage; exit 1
else
	filename="$1"
fi
```
### Check arguments with options
```bash
if [[ "$#" -eq 0 ]]; then
	echo "Error! No argument passed." >&2
	usage
	exit 1
else
	case "$1" in
		--help )
			echo "Help:"
			usage
			exit
		;;
		--install )
			user_in_sudo
			install_package
		;;
		--remove )
			sudo_login 2
			remove_package
		;;
		* )
			echo "Invalid argument" >&2
			usage
			exit 1
	esac
fi
```
