#!/usr/bin/env bash
##########################################################################
# Script Name  : 03-bullseye2bookworm.sh
# Description  : Inplace upgrade from Debian 11 to Debian 12
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 03 Jan 2024
# Last updated : 21 Jul 2025
# Comments     : Final cleanup after upgrade to Debian 12.
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

# set -eu

## Functions ##

check_files() {
	[[ -f "$HOME/01-upgrade" && -f "$HOME/02-sources" ]] && return "$TRUE" || return "$FALSE"
}

version_info() {
	printf "Version information:\n"
	lsb_release -a | sed '1d'
	printf "%-16s%s\n" "Version:" "$(cat /etc/debian_version)"
}

clean_up() {
	sudo_login 2
	printf "Cleaning up after the upgrade...\n"
	printf "\nCleaning the apt cache...\n"
	sudo apt autoclean
	printf "\nRemoving obsolete and unwanted programs...\n"
	sudo apt --purge autoremove
	printf "\nThere may be programs and applications that need to be reinstalled or updated.\n"
	rm "$HOME/01-upgrade" "$HOME/02-sources"
}

main() {
	local script="${0##*/}"
	local version="1.6.25202"
	local updated="21 Jul 2025"
	check_files || die "01-bullseye2bookworm.sh and 02-bullseye2bookworm.sh must be run first." 1
	version_info
	if [[ "$(lsb_release --codename --short | awk 'NR = 1 {print}')" == "bookworm" ]]; then
		printf "Debian inplace upgrade was successful!\n"
	else
		printf "Debian inplace upgrade failed.\nBackup the home directory and any important files, then install from the ISO.\n" >&2
	fi
	clean_up
	over_line "$script $version ($updated)"
	exit
}

## Execution ##

main "$@"
