#!/usr/bin/env bash
###############################################################################
# Script Name  : clean-c.sh
# Description  : removes *~, *.o, and a.out in the current working directory
# Dependencies : none
# Arguments    : none
# Author       : Copyright (C) 2019, Richard Romig,
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 08 Feb 2019
# Updated      : 21 May 2026
# Comment      :
# TODO (rick)  :
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
###############################################################################

## Soruce function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

clean_work_dir() {
	# work_dir=$(dirname "$(readlink -f "$0")")
	printf "Cleaning up %s...\n" "$PWD"
	find . -maxdepth 1 -type f \( -name "a.out" -o -iname "*.o" -o -iname "*~" \) -print -exec rm -v {} \;
}

main() {
  local script="${0##*/}"
  local version="2.4.26141"
	clean_work_dir
	over_line "$script $version"
	exit
}

main "$@"
