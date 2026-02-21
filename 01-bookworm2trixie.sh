#!/usr/bin/env bash
##########################################################################
# Script Name  : 01-bookworm2trixie.sh
# Description  : Inplace upgrade from Debian 12 to Debian 13
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 06 Jun 2025
# Last updated : 21 Feb 2026
# Comments     : This script updates current Debian 12 before upgrade.
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
  exit 81
fi

## Functions ##

check_file1() {
	[[ -f "$HOME/01-upgrade" ]] && return "$TRUE" || return "$FALSE"
}

check_file2() {
	[[ -f "$HOME/02-sources" ]] && return "$TRUE" || return "$FALSE"
}

check_codename() {
	[[ "$(lsb_release --codename --short 2>/dev/null)" == "bookworm" ]] && return "$TRUE" || return "$FALSE"
}

version_info() {
	printf "Version information:\n"
	lsb_release --all 2>/dev/null
	printf "%-16s%s\n" "Version:" "$(cat /etc/debian_version)"
}

upgrade_packages() {
	sudo_login 2
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt autoclean
	sudo apt autoremove --purge -y
}

main() {
	local script="${0##*/}"
	local version="1.5.26052"
	local updated="21 Feb 2026"
	check_codename || die "This is not Debian 12 Bookworm" "$E_INFO"
	check_file1 && die "This script has already been run." "$E_INFO"
	check_file2 && die "This script has already been run." "$E_INFO"
	version_info
	printf "Updating current Debian 12 packages.\n"
	upgrade_packages
	printf "Debian 12 packages have been upgraded.\n"
	printf "Reboot and run 02-bookworm2trixie.sh\n"
	touch "$HOME/01-upgrade"
	over_line "$script $version ($updated)"
	exit
}

## Execution ##

main "$@"
