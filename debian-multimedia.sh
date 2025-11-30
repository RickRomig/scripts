#!/usr/bin/env bash
##########################################################################
# Script Name  : debian-multimedia.sh
# Description  : adds multimedia repository to Debian
# Dependencies : wget
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 28 Oct 2025
# Last updated : 29 Nov 2025
# Comments     :
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

## Global Variables ##

tmp_dir=$(mktemp -qd) || die "Failed to create temporary directory." 1

## Functions ##

# shellcheck disable=SC2317 # Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
cleanup() {
	[[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
}

install_multimedia_keyring() {
	local -r keyring_url="https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring"
	local -r keyring_deb="deb-multimedia-keyring_2024.9.1_all.deb"
	printf "Downloading and installed Debian Multimedia Keyring...\n"
	wget -P "$tmp_dir" "$keyring_url/$keyring_deb"
	sudo dpkg -i "$tmp_dir/$keyring_deb"
}

set_multimedia_sources() {
	local distro="$1"
	local script_dir
	local -r source_list=/etc/apt/sources.list.d/dmo.sources
	script_dir=$(dirname "$(readlink -f "${0}")")
	printf "Setting multimeda sources...\n"
	case "$distro" in
		bookworm )
			sudo cp -v "$script_dir"/files/bookworm-dmo.sources "$source_list" ;;
		trixie )
			sudo cp -v "$script_dir"/files/trixie-dmo.sources "$source_list" ;;
		* )
			# Should not be necessary
	esac
}

exit_script() {
  local -r script="${0##*/}"
  local -r version="2.0.25333"
	over_line "$script $version"
  exit
}

main() {
	local distro
	distro="$(/usr/bin/lsb_release --codename --short)"
	check_package wget
  trap cleanup EXIT
	[[ "$distro" != "bookworm " && "$distro" != "trixie " ]] && { printf "%s is not supported by this script.\n" "${distro^}"; exit_script; }
	install_multimedia_keyring
	set_multimedia_sources "$distro"
	exit_script
}

## Execution ##

main "$@"
