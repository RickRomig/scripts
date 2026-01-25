#!/usr/bin/env bash
##########################################################################
# Script Name  : 02-bookworm2trixie.sh
# Description  : Inplace upgrade from Debian 12 to Debian 13
# Dependencies : apt-transport-https
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 06 Jun 2025
# Last updated : 25 Jan 2026
# Comments     : This scripts updates sources.list & backports.list.
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

## Functions ##

check_files() {
	[[ -f "$HOME/01-upgrade" ]] && return "$TRUE" || return "$FALSE"
}

version_info() {
	printf "Version information:\n"
	lsb_release -a | sed '1d'
	printf "%-16s%s\n" "Version:" "$(cat /etc/debian_version)"
}

sources_list() {
	# Backs up and updates sources list, leaving ftp url as http
	local list_path="/etc/apt/"
	local src_list="sources.list"
	sudo_login 2
	sudo sed -i.bak 's/http:/https:/g;/ftp/s/https:/http:/;s/bookworm/trixie/g' "$list_path/$src_list"
}

backports_list() {
	# Backs up and updates backports list
	local list_path="/etc/apt/sources.list.d"
	local old_name="bookworm-backports.list"
	local new_name="trixie-backports.list"
	if [[ ! -f "$list_path/$old_name" ]]; then
		printf "%s/%s does not exist.\n" "$list_path" "$old_name"
		return
	fi
	sudo_login 2
	sudo sed -i.bak 's/http:/https:/;s/bookworm/trixie/' "$list_path/$old_name"
	# sudo cp -v "$list_path/$old_name" "$list_path/$old_name.bak"
	# find "$list_path" -name "*.list" -exec sudo sed -i.bak 's/bookworm/trixie/g' {} \;
	sudo mv -v "$list_path/$old_name" "$list_path/$new_name"
}

upgrade_debian() {
	# Cleans and updates apt cache, then upgrades to Debian 13.
	sudo apt clean
	sudo apt update
	sudo apt upgrade --without-new-pkgs
	sudo apt full-upgrade
}

main() {
	local script="${0##*/}"
	local version="1.5.26025"
	local updated="25 Jan 2026"
	check_files || die "01-bookworm2trixie.sh must be run first." "$E_INFO"
	check_package apt-transport-https
	version_info
	[[ "$(lsb_release --codename --short | awk 'NR = 1 {print}')" == "bookworm" ]] || die "Unsupported Debian version." 1
	printf "Updatings source lists...\n"
	sources_list
	backports_list
	printf "Upgrading to Debian 13\n"
	upgrade_debian
	printf "Debian 13 Trixie installed.\n"
	printf "Reboot and run 03-bookworm2trixie.sh\n"
	touch "$HOME/02-sources"
	over_line "$script $version ($updated)"
	exit
}

## Execution ##

main "$@"
