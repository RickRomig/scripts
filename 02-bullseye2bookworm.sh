#!/usr/bin/env bash
##########################################################################
# Script Name  : 02-bullseye2bookworm.sh
# Description  :Inplace upgrade from Debian 11 to Debian 12
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 03 Jan 2024
# Last updated : 19 Jul 2025
# Comments     : This scripts updates sources.list & backports.list for upgrade.
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

check_files() {
	[[ -f "$HOME/01-upgrade" ]] && return "$TRUE" || return "$FALSE"
}

version_info() {
	printf "Version information:\n"
	lsb_release -a | sed '1d'
	printf "%-16s%s\n" "Version:" "$(cat /etc/debian_version)"
}

source_list() {
	# Backs up, then updates sources list
	local list_path="/etc/apt/"
	local src_list="sources.list"
	sudo_login 2
	sudo cp -v "$list_path/$src_list" /root/
	sudo sed -i 's/bullseye/bookworm/' "$list_path/$src_list"
}

backports_list() {
	# Backs up, then updates backports list
	local list_path="/etc/apt/sources.list.d"
	local old_name="bullseye-backports.list"
	local new_name="bookworm-backports.list"
	sudo_login 2
	if [[ -f "$list_path/$old_name" ]]; then
		sudo cp -v "$list_path/$old_name" /root/
		sudo sed -i 's/bullseye/bookworm/' "$list_path/$old_name"
		sudo mv -v "$list_path/$old_name" "$list_path/$new_name"
	else
		printf "%s/%s does not exist.\n" "$list_path" "$old_name"
	fi
}

upgrade_debian() {
	# Cleans and updates apt cache, then upgrades to Debian 12.
	sudo apt clean
	sudo apt update
	sudo apt upgrade --without-new-pkgs
	sudo apt full-upgrade
}

main() {
	local script="${0##*/}"
	local version="1.6.25200"
	local updated="19 Jul 2025"
	check_files || die "01-bullseye2bookworm.sh must be run first." 1
	version_info
	[[ "$(cut -d. -f1 /etc/debian_version)" -ne "11" ]] && die "Unsupported Debian version." 1
	printf "Updatings source lists...\n"
	source_list
	backports_list
	printf "Upgrading to Debian 12\n"
	upgrade_debian
	printf "Debian 12 Bookworm installed.\n"
	printf "Reboot and run 03-bullseye2bookworm.sh\n"
	touch "$HOME/02-sources"
	over_line "$script $version ($updated)"
}

## Execution ##

main "$@"
