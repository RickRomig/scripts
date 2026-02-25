#!/usr/bin/env bash
#####################################################################
# Script Name  : devtoolchk.sh
# Description  : Check if C development tools are installed
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2017 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 01 Jan 2017
# Updated      : 24 Feb 2026
# Comment      :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
#####################################################################
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

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 81
fi

check_tools() {
	local package packages
	packages=( binutils build-essential gcc libc6 )
	for package in "${packages[@]}"; do
		printf "%s is " "$package"
		grep -q '^ii' <(dpkg -l "$package" 2>/dev/null 2>&1) && printf "installed.\n" || printf "not installed.\n"
	done
}

main() {
	local script version
	script="${0##*/}"
	version="2.3.26055"
	printf "Checking for deveolopment tools...\n"
	check_tools
	over_line "$script $version"
	exit
}

# Execution

main "$@"
