#!/usr/bin/env bash
##########################################################################
# Script Name  : 01-bullseye2bookworm.sh
# Description  : Inplace upgrade from Debian 11 to Debian 12
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 03 Jan 2024
# Last updated : 06 Jun 2025
# Comments     : This script updates current Debian 11 before upgrade.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
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

set -eu

## Functions ##

check_files() {
	[[ -f "$HOME/01-upgrade" ]] && return "$TRUE" || return "$FALSE"
}

check_codename() {
	lsb_release --codename | grep -q bullseye && return "$TRUE" || return "$FALSE"
}

version_info() {
	printf "Version information:\n"
	lsb_release -a | sed '1d'
	printf "%-16s%s\n" "Version:" "$(cat /etc/debian_version)"
}

upgrade_packages() {
	sudo_login 2
	sudo apt update
	sudo apt full upgrade -y
	sudo apt autoremove --purge -y
}

main() {
	local script="${0##*/}"
	local version="1.5.25157"
	local updated="06 Jun 2025"
	check_codename || die "This is not Debian 11 Bullseye" 1
	check_files && die "This script has already been run." 1
	version_info
	[[ "$(cut -d. -f1 /etc/debian_version)" -ne "11" ]] && die "Unsupported Debian version." 1
	printf "Updating current Debian 11 packages.\n"
	upgrade_packages
	printf "Debian 11 packages have been upgraded.\n"
	printf "Reboot and run 02-bullseye2bookworm.sh\n"
	touch "$HOME/01-upgrade"
	over_line "$script $version ($updated)"
	exit
}

## Execution ##

main "$@"
