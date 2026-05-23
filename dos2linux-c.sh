#!/usr/bin/env bash
###############################################################################
# Script Name  : dos2linux-c.sh
# Description  : removes DOS carriage returns from C/C++ soruce files
# Dependencies : find, sed
# Arguments    : none
# Author       : Copyright (C) 2019, Richard Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Jan 2019
# Updated      : 22 May 2026
# Comment      :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
###############################################################################

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

show_doc() {
	cat << _DOC_
$script removes carriage return characters from C/C++ source code files that
were created on a Windows or DOS system, making them compatible with Linux
editing tools. The script operates on files in the current working directory,
not sub-directories. A backup copy of the orginal file is created.

_DOC_
}

convert_files() {
	local -i count=0
	count=$(wc -l < <(find . -maxdepth 1 -type f \( -name "*.c*" -or -name "*.h" \)))
	if (( count == 0 )); then
		printf "No C/C++ source or header files found.\n" >&2
		return
	fi
	printf "Converting C/C++ source and header files...\n"
	find . -maxdepth 1 -type f \( -name "*.c*" -or -name "*.h" \) -exec sed -i.bak 's/\r//g' '{}' \;
}

main() {
	local -r script="${0##*/}"
	local -r version="2.0.26143"
	show_doc
	convert_files
	over_line "$script $version"
	exit
}

## Execution ##

main "$@"
