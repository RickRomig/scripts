#!/usr/bin/env bash
###############################################################################
# Script Name  : retire-script.sh
# Description  : retire scripts to a zipped archive
# Dependencies : git zip
# Arguments    : -h or --help, optionally script-to-be-retired
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 03 Jul 2026
# Comments     : Do not use with scripts or files inside git repos. Use gretire.sh instead.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
###############################################################################

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source ~/bin/functionlib\n"; exit 1; }

## Functions ##

help() {
  local -r script="$1"
  local -r version="$2"
  local -r errcode="${3:-1}"
  local -r updated="03 Jul 2026"
	cat << _HELP_
${orange}$script${normal} $version ($updated)
Retires a script by moving it to a zipped archive.

${green}Usage:${normal} $script <script-name>
${orange}Available options:${normal}
  -h | --help  Show this help message and exit
${bold}NOTES:${normal}
1. User is prompted to provide a file mame is no arguments are supplied.
2. Do not use to retire a script in a git repository.
3. To properly retire a script in a git repository use 'gretire.sh'.
_HELP_
	exit "$errcode"
}

check_dependencies() {
	local packages=(git zip)
	check_packages "${packages[@]}"
	return 0
}

check_git_repo() {
	[[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] && return "$TRUE" || return "$FALSE"
}

chack_args() {
	local -r filename="$1"
	if [[ ! -f "$filename" ]]; then
		printf "%s was not found in this directory.\n" "$filename" >&2
		return "$E_FILENOTFOUND"
	fi
	retire_script "$filename"
	return 0
}

retire_script() {
	local ret_name
	local -r archive_dir=~/Downloads/archives
	local -r ret_archive="retired-scripts.zip"
	local -r filename="$1"
	ret_name="${filename}.$(date +'%y%j')"
	mv -v "$filename" "$ret_name"
	zip -um "$archive_dir/$ret_archive$" "$ret_name"
	printf "%s has been retired and archived.\n" "$filename"
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="3.5.26184"
	local -i exit_code=0
	[[ "$1" == "-h" || "$1" == "--help" ]] && help "$script" "$version" 0
	check_git_repo && die "This is a git repository. Use 'gretire.sh' to retire a script inside a git repository." 1
	local filename="$1"
	[[ "$filename" ]] || read -rp "Enter a script to be retired: " filename
	check_dependencies
	chack_args "$filename"
	exit_code="$?"
  over_line "$script $version"
	exit "$exit_code"
}

## Execution ##

main "$@"
