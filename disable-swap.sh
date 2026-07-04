#!/usr/bin/env bash
##########################################################################
# Script Name  : disable-swap.sh
# Description  : disables swap file/partition
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Jan 2025
# Last updated : 04 Jul 2026
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

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

disable_swap_device() {
	local swap_dev="$1"
	printf "Current swap is %s\n" "$swap_dev"
	if yes_or_no "Do you want to disable ${swap_dev}?"; then
		sudo sed -i.bak '/swap/s/^UUID=/# UUID=/' /etc/fstab
		sudo swapoff "$swap_dev"
		printf "%s is disabled as swap.\n" "$swap_dev"
	else
		printf "%s remains enabled as swap.\n" "$swap_dev"
	fi
	return 0
}

check_swap_device() {
	local swap_dev
	swap_dev=$(awk '/file/ || /partition/ {print $1}' /proc/swaps)
	[[ "$swap_dev" ]] || { printf "No swap device detected.\n"; return 0; }
	case "$swap_dev" in
		"/dev/zram0" )
			printf "zram-tools installed and active swap.\nNo changes made.\n" ;;
		* )
			disable_swap_device "$swap_dev"
	esac
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="2.2.26185"
	local exit_code=0
	check_swap_device
	exit_code="$?"
	over_line "$script $version"
	exit "$exit_code"
}

## Execution ##

main "$@"
