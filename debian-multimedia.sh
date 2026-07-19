#!/usr/bin/env bash
###############################################################################
# Script Name  : debian-multimedia.sh
# Description  : adds multimedia repository to Debian Bookworm and Trixie
# Dependencies : wget
# Arguments    : None
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 28 Oct 2025
# Last updated : 19 Jul 2026
# Comments     : Tested with Debian 12 (bookworm) & Debian 13 (trixie)
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
# ANY WARRANTY; without even the implied warranty of# MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
###############################################################################

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

# ShellCheck may incorrectly believe that code is unreachable if it's invoked by a variable name or in a trap.
# shellcheck disable=SC2317 # Don't warn about unreachable commands in this function
cleanup() {
	[[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}

install_keyring() {
	local -r keyring_url="https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring"
	local -r keyring_deb="deb-multimedia-keyring_2024.9.1_all.deb"
	printf "Downloading and installed Debian Multimedia Keyring...\n"
	wget -P "$TMP_DIR" "$keyring_url/$keyring_deb"
	sudo dpkg -i "$TMP_DIR/$keyring_deb"
	return "$?"
}

set_sources() {
	local -r distro="$1"
	local -r sources_file=/etc/apt/sources.list.d/dmo.sources
	local -r dmo_key=/usr/share/keyrings/deb-multimedia-keyring.gpg
	local -r sources_uri="https://www.deb-multimedia.org"
	printf "Setting multimeda sources...\n"
	tee $sources_file <<< \
"Types: deb
URIs: $sources_uri
Suites: $distro
Components: main non-free
Signed-By: $dmo_key
Enabled: yes

# Backports
Types: deb
URIs: $sources_uri
Suites: $distro-backports
Components: main
Signed-By: $dmo_key
Enabled: yes"
	printf "Debian mulitimedia repository sources set.\n"
	return 0
}

install_multimedia() {
	local distro
	distro="$(/usr/bin/lsb_release --codename --short)"
	case "$distro" in
		bookworm|trixie )
			sudo_login 2
			check_package wget
			install_keyring && set_sources "$distro" ;;
		* )
			printf "%s is not supported by this script.\n" "${distro^}"
			return "$E_UNSUPPORTED"
	esac
	return "$?"
}

main() {
  local -r script="${0##*/}"
  local -r version="3.0.26200"
	local -i exit_code=0
	TMP_DIR=$(mktemp -qd) || die "Failed to create temporary directory." "$E_TEMP_DIR"
  trap cleanup EXIT
	install_multimedia
	exit_code="$?"
	over_line "$script $version"
  exit "$exit_code"
}

main "$@"
