#!/usr/bin/env bash
##########################################################################
# Script Name  : retire-script.sh
# Description  : retire scripts to a zipped archive
# Dependencies : git zip
# Arguments    : -h or --help, optionally script-to-be-retired
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 18 Sep 2025
# Comments     : Do not use with scripts or files inside git repos. Use gretire instead.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
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
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Global Variables ##

readonly script="${0##*/}"
readonly version="2.0.252261"

## Functions ##

help() {
	local errcode="${1:-2}"
	local updated=" 18 Sep 2025"
	cat << _HELP_
${orange}$script${normal} $version ($updated)
Retires a script by moving it to a zipped archive.

${green}Usage:${normal} $script <script-name>
${orange}Available options:${normal}
  -h | --help  Show this help message and exit
${bold}NOTES:${normal}
1. Do not use to retire a script in a git repository such as ~/Projects or ~/gitea
2. To properly retire a script in a git repository use gretire.sh
_HELP_
	exit "$errcode"
}

check_dependencies() {
	local packages=(git zip)
	check_packages "${packages[@]}"
}

retire_script() {
	local foo foobar archive_dir ret_archive
	foo="$1"
	archive_dir="$HOME/Downloads/archives"
	ret_archive="retired-scripts.zip"
	foobar="${foo}.$(date +'%y%j')"
	mv -v "$foo" "$foobar"
	zip -um "$archive_dir/$ret_archive$" "$foobar"
}

main() {
	local ret_script
	check_dependencies
	if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
		printf "%s %s is an invalid script here. This is a Git repository." "$RED_WARNING" "$script"  >&2
		help 1
	elif [[ "$#" -eq 0 ]]; then
    read -rp "Enter a script to retire: " ret_script
		if [[ -f "$ret_script" ]]; then
			retire_script "$ret_script"
		else
			printf "%s %s not found.\n" "$RED_ERROR" "$ret_script" >&2
			help 2
		fi
	elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
		help 0
	elif [[ ! -f "$1" ]]; then
		printf "%s %s not found.\n" "$RED_ERROR" "$1" >&2
		help 2
	else
		ret_script="$1"
		retire_script "$ret_script"
	fi
	over_line "$script $version"
	exit 0
}

## Execution ##

main "$@"
