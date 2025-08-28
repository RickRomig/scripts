#!/usr/bin/env bash
#####################################################################
# Script Name  : c-menu.sh
# Description  : menu for C programming
# Dependencies : binutils, gcc
# Arguments    : none
# Author       : Richard B. Romig, LudditeGeek@Mosfnet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : Unknown
# Updated      : 27 Aug 2025
# Comments     : Run from current working directory
# TODO (rick)  :
# License      : GNU General Public License, version 2
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
##########################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#####################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

set -eu

## Functions ##

check_dependencies() {
	local packages=( binutils gcc )
	check_packages "${packages[@]}"
	if locate glibc > /dev/null 2>&1; then printf "glibc - OK\n"; else sudo apt-get install glibc-source -yyq; fi
	if [[ -d "/usr/include" ]]; then printf "build-essential - OK\n"; else sudo apt-get install build-essential -yyq; fi
	if exists fnloc; then printf "fnloc - OK\n"; else printf "Install fnloc from repository.\n"; fi
	anykey
}

edit_souce_code() {
	local fname
	clear
	read -rp "Enter filename to edit: " fname
  if [[ -f "$fname" ]]; then
		"$EDITOR" "$fname"
  else
    printf "%s %s not found.\n" "$RED_ERROR" "$fname" >&2
  fi
	anykey
}

compile_a_out() {
	local fname
	clear
	read -rp "Enter file to be compiled to a.out (with the .c extension): " fname
	if [[ -f "$fname" ]]; then
    printf "Compiling %s to a.out\n" "$fname"
		/usr/bin/gcc "$fname"
	else
    printf "%s %s not found.\n" "$RED_ERROR" "$fname" >&2
	fi
	anykey
}

compile_with_name() {
	local fname ext
	clear
	read -rp "Enter file to be compiled: " fname
	ext="${fname##*.}"
	[[ "$ext" ]] && fname="${fname%.*}"	# filename without the extension
	if [[ -f "$fname.c" ]]; then
    printf "Compiling %s.%s to %s\n" "$fname" "$ext" "$fname"
	  /usr/bin/gcc "$fname.$ext" -o "$fname"
	else
    printf "%s %s not found.\n" "$RED_ERROR" "$fname" >&2
	fi
	anykey
}

print_loc_screen() {
	local fname
	clear
	if [[ -x /usr/local/bin/fnloc ]]; then
		read -rp "Enter source code file for LOC count (Print to screen): " fname
		if [[ -f "$fname" ]]; then
			/usr/local/bin/fnloc "$fname"
			anykey
		else
			printf "%s %s not found.\n" "$RED_ERROR" "$fname" >&2
		fi
	else
		printf "FnLoC is not installed.\n"
	fi
	anykey
}

save_loc_file() {
	local fname
	clear
	if [[ -x /usr/local/bin/fnloc ]]; then
	read -rp "Enter source code file for LOC count (Print to file): " fname
		if [[ -f "$fname" ]]; then
			/usr/local/bin/fnloc $"$fname" > "${fname//.c/.loc}"
		else
			printf "%s %s not found.\n" "$RED_ERROR" "$fname" >&2
		fi
	else
		printf "FnLoC is not installed.\n"
	fi
	anykey
}

view_source_code() {
	local fname
	clear
  read -rp "Enter source code file to view: " fname
  if [[ -f "$fname" ]]; then
	  if exists bat; then
      "$HOME"/.local/bin/bat "$fname"
    else
			viewtext "$fname"
    fi
  else
		printf "%s %s not found.\n" "$RED_ERROR" "$fname" >&2
  fi
	anykey
}

cleaning_up() {
	clear
	printf "Cleaning up ...\n"
	/usr/bin/find . -maxdepth 1 -type f \( -name "a.out" -o -iname "*.o" -o -iname "*~" \) -print -exec rm {} \;
	anykey
}

main() {
	local script="${0##*/}"
	local version="3.1.25239"
	local _opt options
	check_dependencies
	while true; do
		clear
		box "C Work Menu" "="
		options=("Edit a file" "Compile code to a.out" "Compile code with -o option" "Display Lines of Code" \
    "Print LOC to a file" "View code" "Clean up extraneous files" "Quit")
		PS3="Choose an option: "
		select _opt in "${options[@]}"; do
			case $REPLY in
				1 )
					edit_souce_code
					break ;;
				2 )
					compile_a_out
					break ;;
				3 )
					compile_with_name
					break ;;
				4 )
					print_loc_screen
					break ;;
				5 )
					save_loc_file
					break ;;
				6 )
					view_source_code
					break ;;
				7 )
					cleaning_up
					break ;;
				8 )
					break 2 ;;
				* )
					printf "%s Not a valid option. Please try again.\n" "$RED_ERROR" >&2
			esac
		done
	done
	over_line "$script $version"
	exit
}

## Execution ##

main "$@"
