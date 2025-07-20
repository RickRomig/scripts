#!/usr/bin/env bash
##########################################################################
# Script Name  : http2https.sh
# Description  : Change http to https in sources.list & backports.list
# Dependencies :
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 20 Jul 2025
# Last updated : 20 Jul 2025
# Comments     : Intended for use on Debian
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

set -eu

## Functions ##

debian_distro() {
	local codename
	codename=$(/usr/bin/lsb_release --codename --short | awk 'NR = 1 {print $0}')
	printf "%s" "$codename"
}

http_to_https() {
	local backports_list="${1}-backports.list"
	sudo_login 2
	sudo sed -i.bak 's/http:/https:/' /etc/apt/sources.list
	[[ -f "/etc/apt/sources.list.d/$backports_list" ]] && sudo sed -i.bak 's/http:/https:/' "/etc/apt/sources.list.d/$backports_list"
}

main() {
	local -r script="${0##*/}"
	local -r version="1.0.25201"
	local distro
	distro=$(debian_distro)
	case "$distro" in
		bookworm|trixie )
			http_to_https "$distro" ;;
		* )
			printf "%s is not supported by this script!\n" "$distro" >&2
	esac
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
