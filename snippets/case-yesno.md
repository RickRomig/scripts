# Yes/No Prompts

#### Type in foll reply, case insensitive
```bash
while true; do
	read -rp "Do you wish to continue? [Yes|No]" yesno
	case "${yesno,,}" in
		yes )
			echo "Continue..."
			break
		;;
		no )
			echo "Script canceled. No action taken."
			shopt -u nocasematch
			break
		;;
		* )
			echo "Invalid choice. Must enter Yes or No"
	esac
done
```
#### Type in foll reply, case sensitive
```bash
while true; do
  read -rp "Do you wish to continue? [yes/no]? " yesno
  case "$yesno" in
    yes )
      echo "Continue..."
      break
    ;;
    no )
      printf "Operation canceled. No action taken.\n"
      break
    ;;
    * )
      printf "Invalid choice. Enter yes or no.\n" >&2
  esac
done
```
####  Single letter y or n, case insensitive
```bash
read -rp -n1 "Do you want to continue? [y|N] " yn
case "$yn" in
	[Yy] )
		echo "Yes I want to continue."
	;;
	[Nn] )
		echo "No, I don't want to continue."
	;;
	* )
		echo " Go with the default response."
esac
```
####  Single letter y or n, case insensitive. No response is the default.
```bash
read -rp -n1 "Do you want to continue? [y|N] " yn
case "$yn" in
	[Yy] )
		echo "Yes I want to continue."
	;;
	* )
		echo " Go with the default response."
esac
```
#### Y or N, response required
```bash
askyn() {
	while :; do
		read -p "$1 (Y/N) "
		case "${REPLY,,}" in
			y|yes )
				return 0
			;;
			n|no )
				return 1
			;;
			'' )
				echo "Response required -- try again." >&2
			;;
			* )
				echo "Invalid response -- try again." >&2
		esac
	done
}
```
#### Simple confirmation
```bash
read -rp "Do you want to continue (y/n) " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && { printf "Installation canceled.\n" >&2; exit; }
```