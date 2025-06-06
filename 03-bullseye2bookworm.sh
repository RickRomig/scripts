#!/usr/bin/env bash
##########################################################################
# Script Name  : 03-bullseye2bookworm.sh
# Description  : Inplace upgrade from Debian 11 to Debian 12
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 03 Jan 2024
# Last updated : 05 Jun  2025
# Comments     : Final cleanup after upgrade to Debian 12.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091

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
	local version="1.3.25156"
	local updated="05 Jun 2025"
	check_files || die "01-bullseye2bookworm.sh and 02-bullseye2bookworm.sh must be run first." 1
	version_info
	if [[ "$(cut -d. -f1 /etc/debian_version)" -ne "12" ]]; then
		die "Debian inplace upgrade failed." 1
	else
		printf "Debian inplace upgrade was successful!\n"
	fi
	clean_up
	over_line "$script $version ($updated)"
	exit
}

## Execution ##

main "$@"
