#!/usr/bin/env bash
##########################################################################
# Script Name  : 03-bookworm2trixie.sh
# Description  : Inplace upgrade from Debian 11 to Debian 12
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 06 Jun 2025
# Last updated : 26 Jun 2026
# Comments     : Cleanup after upgrade to Debian 13.
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

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

check_file1() {
	[[ -f "$HOME/01-upgrade" ]] && return "$TRUE" || return "$FALSE"
}

check_file2() {
	[[ -f "$HOME/02-sources" ]] && return "$TRUE" || return "$FALSE"
}

check_codename() {
	[[ "$(lsb_release --codename --short 2>/dev/null)" == "trixie" ]] && return "$TRUE" || return "$FALSE"
}

version_info() {
	printf "Version information:\n"
	lsb_release --all 2>/dev/null
	printf "%-16s%s\n" "Version:" "$(< /etc/debian_version)"
}

clean_up() {
	sudo_login 2
	printf "%sCleaning up after the upgrade...%s\n" "$orange" "$normal"
	printf "\n%sCleaning the apt cache...%s\n" "$orange" "$normal"
	sudo apt autoclean
	printf "\n%sRemoving obsolete and unwanted programs...%s\n" "$orange" "$normal"
	sudo apt --purge autoremove
	printf "\nThere may be programs and applications that need to be reinstalled or updated.\n"
	rm -v "$HOME/01-upgrade" "$HOME/02-sources"
}

modernize_sources() {
	printf "Modernizing sources...\n"
	[[ -f "/etc/apt/sources.list.d/debian.sources" ]] || sudo apt modernize-sources
}

main() {
	local script="${0##*/}"
	local version="1.8.26177"
	local updated="26 Jun 2026"
	local exit_code=0
	check_file1 || die "01-bookworm2trixie.sh and 02-bookworm2trixie.sh must be run first." "$E_INFO"
	check_file2 || die "02-bookworm2trixie.sh hasn't been run." "$E_INFO"
	version_info
	if check_codename; then
		printf "%sDebian inplace upgrade was successful!%s\n" "$orange" "$normal"
		clean_up
		modernize_sources
	else
		printf "Debian inplace upgrade failed.\n" >&2
		printf "Backup the home directory and any important files, then install from the ISO.\n" >&2
		exit_code="$E_INSTALLATION"
	fi
	over_line "$script $version ($updated)"
	exit "$exit_code"
}

## Execution ##

main "$@"
