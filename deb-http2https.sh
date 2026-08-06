#!/usr/bin/env bash
###############################################################################
# Script Name  : deb-http2https.sh
# Description  : Change http to https in sources.list & backports.list in Debian
# Dependencies : apt-transport-https
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 20 Jul 2025
# Updated      : 06 Aug 2026
# Version      : 1.7.26218
# Comments     : Intended for use on Debian Bookworm, and Trixie
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
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

debian_distro() {
	printf "%s" "$(/usr/bin/lsb_release -cs 2>/dev/null)"
	return 0
}

convert_sources_list() {
	if grep -q 'deb https' /etc/apt/sources.list; then
		printf "\nSources.list has already been converted\n"
		return 0
	fi
	sudo_login 2
	sudo sed -i.bak 's/http:/https:/;/ftp/s/https:/http:/' /etc/apt/sources.list
	printf "\nChanged http to https in sources.list\n"
	return 0
}

convert_backports_list() {
	local -r backports_list="${1}-backports.list"
	if [[ ! -f "/etc/apt/sources.list.d/$backports_list" ]]; then
		printf "%s does not exist on this system.\n" "$backports_list"
		return 0
	fi
	if grep -q 'deb https' "/etc/apt/sources.list.d/$backports_list"; then
		printf "%s has already been converted\n" "$backports_list"
		return 0
	fi
	sudo_login 2
	sudo sed -i.bak 's/http:/https:/' "/etc/apt/sources.list.d/$backports_list"
	printf "Changed http to https in %s\n" "$backports_list"
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="1.7.26218"
	local -i exit_code=0
	local distro
	distro=$(debian_distro)
	check_package apt-transport-https
	case "$distro" in
		bookworm|trixie )
			if [[ -f /etc/apt/sources.list.d/debian.sources ]]; then
				printf "Sources list has been modernized.\n"
			else
				convert_sources_list
				convert_backports_list "$distro"
			fi
			;;
		* )
			printf "%s does not support %s\n" "$script" "${distro^}" >&2
			exit_code="$E_UNSUPPORTED"
	esac
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
