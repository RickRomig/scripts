#!/usr/bin/env bash
##########################################################################
# Script Name  : disable-swap.sh
# Description  : disables swap file/partition
# Dependencies : none
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Jan 2025
# Last updated : 16 Jul 2025
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

set -eu

## Functions ##

main() {
	local script version swap_dev
	script="${0##*/}"
	version="1.9.25174"
	swap_dev=$(awk '/file/ || /partition/ {print $1}' /proc/swaps)
	if [[ "$swap_dev" ]]; then
		case "$swap_dev" in
			"/dev/zram0" )
				printf "zram-tools installed and active swap.\n"
				;;
			* )
				printf "Current swap is %s\n" "$swap_dev"
				if yes_or_no "Do you want to disable ${swap_dev}?"; then
					sudo sed -i.bak '/swap/s/^UUID=/# UUID=/' /etc/fstab
					sudo swapoff "$swap_dev"
					printf "%s is disabled as swap.\n" "$swap_dev"
				else
					printf "%s remains enabled as swap.\n" "$swap_dev"
				fi
		esac
	else
		printf "No swap device detected.\n"
	fi
	over_line "$script $version"
	exit
}

## Execution ##

main "$@"
