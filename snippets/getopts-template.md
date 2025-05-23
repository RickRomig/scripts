# Basic usage for getopts in installation scripts
red_error variable declared in functionlib
```bash

help() {
	errcode="${1:-2}"
	cat << END_HELP
${green}Usage:${normal} $_script [OPTION]
${orange}OPTIONS:${normal}
	-h 	Display help
	-i 	Install application
	-r 	Remove application
	-s  Apply settings
	-u 	Update application
END_HELP
	exit "$errcode"
}

show_me() {
	local message="$1"
	[[ "$verbose_mode" == "$TRUE" ]] && echo "$message"
}

## Execution ##

verbose_mode="$FALSE"
noOpt=1
optstr=":hirsuv"
# optstr=":h:i:r:s:u"
while getopts "$optstr" opt; do
	case "$opt" in
		h )
			help 0
		;;
		i )
			# argI="$OPTARG"
			install_application
			apply_settings	# optional custom configuration
		;;
		r )
			# argR="$OPTARG"
			remove_application
		;;
		s )
			apply_settings
		;;
		u )
			exists application || leave "Application is not installed. run '$_script -i' to install."
			update_application
		;;
		v )
			verbose_mode="$TRUE"
			show_me "Verbose mode enabled."
		;;
		: )
		  # echo "${lightred}ERROR:${normal} Must supply an argument to -${OPTARG}." >&2
			# printf "\e[91mERROR:\e[0m Must supply an argument to -%s.\n" "$OPTARG" >&2
			printf "%s Must supply an argument to -%s.\n" "$red_error" "$OPTARG" >&2
		  help 2
		;;
		? )
			# echo "${lightred}ERROR:${normal} Invalid option -${OPTARG}" >&2
			# printf "\e[91mERROR:\e[0m Invalid option -%s\n" "$OPTARG" >&2
			printf "%s Invalid option -%s\n" "$red_error" "$OPTARG" >&2
			help 2
	esac
	noOpt=0
done
# [[ "$noOpt" = 1 ]] && { echo "${lightred}ERROR:${normal} No argument passed." >&2; help 1; }
[[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$red_error" >&2; help 1; }
shift "$(( OPTIND - 1 ))"
leave "$_script v$_version (Updated: $_updated)"
```