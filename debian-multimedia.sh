#!/usr/bin/env bash
##########################################################################
# Script Name  : debian-multimedia.sh
# Description  : adds multimedia repository to Debian
# Dependencies : none
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 28 Oct 2025
# Last updated : 07 Nov 2025
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

script_dir=$(dirname "$(readlink -f "${0}")"); readonly script_dir
tmp_dir=$(mktemp -qd) || die "Failed to create temporary directory." 1

## Functions ##

# shellcheck disable=SC2317 # Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
cleanup() {
	[[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
}

debian_distro() {
	local codename
	codename=$(/usr/bin/lsb_release --codename --short | awk 'NR = 1 {print}')
	printf "%s" "$codename"
}

install_multimedia_keyring() {
	local distro="$1"
	[[ "$distro" != "bookworm " && "$distro" != "trixie " ]] && { notify-send -t 2000 "${distro^} is not supported"; return; }
	local -r keyring_url="https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring"
	local -r keyring_deb="deb-multimedia-keyring_2024.9.1_all.deb"
	# download and install multimedia keyring
	wget -P "$tmp_dir" "$keyring_url/$keyring_deb"
	sudo dpkg -i "$tmp_dir/$keyring_deb"
}

set_multimedia_sources() {
	local distro="$1"
	local -r source_list=/etc/apt/sources.list.d/dmo.sources
	case "$distro" in
		bookworm )
			sudo cp -v "$script_dir"/files/bookworm-dmo.sources "$source_list" ;;
		trixie )
			sudo cp -v "$script_dir"/files/trixie-dmo.sources "$source_list" ;;
		* )
			printf "%s is not supported by this script.\n" "${distro^}" >&2
	esac
}

main() {
  local -r script="${0##*/}"
  local -r version="1.1.25311"
	local distro
	distro=$(debian_distro)

  trap cleanup EXIT

	install_multimedia_keyring "$distro"
	set_multimedia_sources "$distro"

  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
