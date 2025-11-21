#!/usr/bin/env bash
#####################################################################
# Script Name  : dos2linux-c.sh
# Description  : removes DOS carriage returns from C/C++ soruce files
# Dependencies : find, sed
# Arguments    : none
# Author       : Copyright (C) 2019, Richard Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Jan 2019
# Updated      : 21 Nov 2025
# Comment      :
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
#####################################################################

## Functions ##

show_doc() {
	cat << _DOC_
$script removes carriage return characters from C/C++ source code files that
were created on a Windows or DOS system, making them compatible with Linux
editing tools. The script operates on files in the current working directory,
not sub-directories.
A backup copy of the orginal file is created.

_DOC_
}

convert_files() {
	printf "Converting C/C++ source files...\n"
	find . -maxdepth 1 -type f -iname "*.c*" -exec sed -i.bak 's/\r//g' '{}' \;
	printf "Converting C/C++ header files...\n"
	find . -maxdepth 1 -type f -iname "*.h*" -exec sed -i.bak 's/\r//g' '{}' \;
}

main() {
	local -r script="${0##*/}"
	local -r version="1.3.25325"
	show_doc
	convert_files
	over_line "$script $version"
	exit
}

## Execution ##

main "$@"
