#!/usr/bin/env bash
##############################################################################
# Script Name  : devtoolchk.sh
# Description  : Check if C development tools are installed
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2017 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 01 Jan 2017
# Updated      : 06 Aug 2026
# Version      : 2.4.26218
# Comment      :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
##############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

check_tools() {
	local package packages
	packages=( binutils build-essential gcc libc6 )
	printf "Checking for development tools...\n"
	for package in "${packages[@]}"; do
		printf "%s is " "$package"
		installed "$package" && printf "installed.\n" || printf "not installed.\n"
	done
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="2.4.26218"
	check_tools
	over_line "$script $version"
	exit
}

# Execution

main "$@"
