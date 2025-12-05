#! /usr/bin/env bash
##########################################################################
# Script Name  : umount-usb.sh
# Description  : script to unmount a USB drive in the /media/<user> directory
# Dependencies : fzf
# Arguments    : none
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 12 Mar 2025
# Last updated : 05 Dec 2025
# Comments     : Only unmounts devices belonging to the current user.
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

# Load function library

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

check_usb() {
	[[ $(grep 'usb' <(lsblk -S -o TRAN)) = *usb* ]] && return 0 || return 1
}

unmount_usb() {
	local user usb_drive
	check_usb || { printf "No USB drive connected!\n" >&2; return; }
	user=$(whoami)
	usb_drive=$(find /media/"$user" -maxdepth 1 -type d -user "$user" | fzf --height 40% --reverse --prompt "Select the USB drive to unmount: ")
	[[ "$usb_drive" ]] || { printf "No USB drives mounted!\n" >&2; return; }
	umount -l "$usb_drive"
	printf "\"%s\" unmounted or selected.\n" "$usb_drive"
	[[ -d "$usb_drive" ]] && rmdir "$usb_drive"
}

main() {
	local script="${0##*/}"
	local version="2.0.25339"
	check_package fzf
	unmount_usb
	over_line "$script $version"
	exit
}

main "$@"
