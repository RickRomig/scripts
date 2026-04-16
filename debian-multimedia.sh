#!/usr/bin/env bash
##########################################################################
# Script Name  : debian-multimedia.sh
# Description  : adds multimedia repository to Debian
# Dependencies : wget
# Arguments    : None
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 28 Oct 2025
# Last updated : 16 Apr 2026
# Comments     : Only supports Debian 12 (bookworm) & Debian 13 (trixie)
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

## Load function library ##
# shellcheck source=/home/rick/bin/functionlib
source functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Global Variables ##

TMP_DIR=$(mktemp -qd) || die "Failed to create temporary directory." "$E_TEMP_DIR"
EC=0

## Functions ##

# Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
# shellcheck disable=SC2317
cleanup() {
	[[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}

install_multimedia_keyring() {
	local -r keyring_url="https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring"
	local -r keyring_deb="deb-multimedia-keyring_2024.9.1_all.deb"
	printf "Downloading and installed Debian Multimedia Keyring...\n"
	wget -P "$TMP_DIR" "$keyring_url/$keyring_deb"
	sudo dpkg -i "$TMP_DIR/$keyring_deb"
}

set_multimedia_sources() {
	local distro="$1"
	local script_dir
	local -r source_list=/etc/apt/sources.list.d/dmo.sources
	script_dir=$(dirname "$(readlink -f "${0}")")
	printf "Setting multimeda sources...\n"
	case "$distro" in
		bookworm )
			if [[ ! -f "$script_dir/files/bookworm-dmo.sources" ]]; then
				printf "%s bookworm-dmo.sources not found.\n" "$RED_ERROR" >&2
				EC="$E_FILENOTFOUND"
				return
			fi
			sudo cp -v "$script_dir"/files/bookworm-dmo.sources "$source_list"
			;;
		trixie )
			if [[ ! -f "$script_dir/files/trixie-dmo.sources" ]]; then
				printf "%s trixie-dmo.sources not found.\n" "$RED_ERROR" >&2
				EC="$E_FILENOTFOUND"
				return
			fi
			sudo cp -v "$script_dir"/files/trixie-dmo.sources "$source_list"
			;;
		* )
			# Should not be necessary
	esac
}

main() {
  local -r script="${0##*/}"
  local -r version="2.3.26106"
	local distro
	distro="$(/usr/bin/lsb_release --codename --short)"
  trap cleanup EXIT
	check_package wget
	[[ "$distro" != "bookworm " && "$distro" != "trixie " ]] && { printf "%s is not supported by this script.\n" "${distro^}"; exit 1; }
	install_multimedia_keyring
	set_multimedia_sources "$distro"
	over_line "$script $version"
  exit "$EC"
}

## Execution ##

main "$@"
