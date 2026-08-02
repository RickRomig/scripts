#!/usr/bin/env bash
##########################################################################
# Script Name  : 02-bookworm2trixie.sh
# Description  : Inplace upgrade from Debian 12 to Debian 13
# Dependencies : apt-transport-https
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 06 Jun 2025
# Updated      : 02 Aug 2026
# Version      : 1.10.26214
# Comments     : This scripts updates sources.list & backports.list.
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

sources_list() {
	# Backs up and updates sources list, leaving ftp url as http
	local list_path="/etc/apt/"
	local src_list="sources.list"
	sudo_login 2
	printf "%sUpdatings sources lists...%s\n" "$orange" "$normal"
	sudo sed -i.bak 's/http:/https:/g;/ftp/s/https:/http:/;s/bookworm/trixie/g' "$list_path/$src_list"
  return 0
}

backports_list() {
	# Backs up and updates backports list
	local list_path="/etc/apt/sources.list.d"
	local old_name="bookworm-backports.list"
	local new_name="trixie-backports.list"
	printf "%sUpdating backports sources list...%s\n" "$orange" "$normal"
	if [[ ! -f "$list_path/$old_name" ]]; then
		printf "%s/%s does not exist.\n" "$list_path" "$old_name"
		return 0
	fi
	sudo_login 2
	sudo sed -i.bak 's/http:/https:/;s/bookworm/trixie/' "$list_path/$old_name"
	# sudo cp -v "$list_path/$old_name" "$list_path/$old_name.bak"
	# find "$list_path" -name "*.list" -exec sudo sed -i.bak 's/bookworm/trixie/g' {} \;
	sudo mv -v "$list_path/$old_name" "$list_path/$new_name"
  return 0
}

upgrade_debian() {
	# Cleans and updates apt cache, then upgrades to Debian 13.
	printf "%sUpgrading to Debian 13 Trixie...%s\n" "$orange" "$normal"
	sudo_login 2
	sudo apt clean
	sudo apt update
	printf "%sUpgrade without new packages...%s\b" "$orange" "$normal"
	sudo apt upgrade --without-new-pkgs
	printf "%sFull upgrade...%s\n" "$orange" "$normal"
	sudo apt full-upgrade
	printf "%sDebian 13 Trixie installed.%s\n" "$orange" "$normal"
  return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="1.10.26214"
	local -r updated="02 Aug 2026"
	check_package apt-transport-https
	version_info
	check_file1 || die "01-bookworm2trixie.sh must be run first." "$E_FILENOTFOUND"
	check_file2 && die "This script has already been run." "$E_FILE_EXISTS"
	sources_list
	backports_list
	upgrade_debian
	printf "Reboot and run 03-bookworm2trixie.sh\n"
	touch "$HOME/02-sources"
	over_line "$script $version ($updated)"
	exit
}

main "$@"
