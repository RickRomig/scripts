#!/usr/bin/env bash
###############################################################################
# Script Name  : 01-bookworm2trixie.sh
# Description  : Inplace upgrade from Debian 12 to Debian 13
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 06 Jun 2025
# Updated      : 02 Aug 2026
# Version      : 2.0.26214
# Comments     : This script updates current Debian 12 before upgrade.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful,# but WITHOUT
# ANY WARRANTY; without even the implied warranty of# MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

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
	printf "%sVersion information%s:\n" "$orange" "$normal"
	lsb_release --all 2>/dev/null
	printf "%-16s%s\n" "Version:" "$(< /etc/debian_version)"
	check_codename || die "Only upgrade from Debian 12 Bookworm is supported." "$E_UNSUPPORTED"
  return 0
}

upgrade_packages() {
	printf "%sUpdating current Debian 12 packages.%s\n" "$orange" "$normal"
	sudo_login 2
	printf "%sCreating a Timeshift snapshot of current system state.%s\n" "$orange" "$normal"
	installed timeshift && sudo timeshift --create --comments "pre-Trixie update" --tags O
	printf "%sUpdating Bookworm packages and cleaning up.%w\n" "$orange" "$normal"
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt autoclean
	sudo apt autoremove --purge -y
	printf "%sDebian 12 packages are up to date.%s\n" "$orange" "$normal"
  return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="2.0.26214"
	local -r updated="02 Aug 2026"
	version_info
	check_file1 || check_file2 && die "This script has already been run." "$E_FILE_EXISTS"
	upgrade_packages
	printf "Reboot and run 02-bookworm2trixie.sh\n"
	touch "$HOME/01-upgrade"
	over_line "$script $version ($updated)"
	exit
}

main "$@"
