#! /usr/bin/env bash
###############################################################################
# Script Name  : umount-usb.sh
# Description  : script to unmount a USB drive in the /media/<user> directory
# Dependencies : fzf
# Arguments    : none
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 12 Mar 2025
# Last updated : 05 Aug 2026
# Version      ; 2.3.26217
# Comments     : Only unmounts devices belonging to the current user.
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

check_usb() {
	[[ $(grep 'usb' <(lsblk -S -o TRAN)) = *usb* ]] && return "$TRUE" || return "$FALSE"
}

unmount_usb() {
	local user usb_drive
	check_usb || { printf "No USB drive connected!\n" >&2; return "$E_DRIVE_ERROR"; }
	user=$(whoami)
	usb_drive=$(fzf --height 40% --reverse --prompt "Select the USB drive to unmount: " < <(find /media/"$user" -maxdepth 1 -type d -user "$user"))
	[[ "$usb_drive" ]] || { printf "No USB drives mounted or selected!\n" >&2; return "$E_DRIVE_ERROR"; }
	umount -l "$usb_drive"
	printf "\"%s\" unmounted.\n" "$usb_drive"
	[[ -d "$usb_drive" ]] && rmdir "$usb_drive"
	pgrep -x nemo >/dev/null && nemo --quit	# If Nemo is running, close it.
	retunn "$?"
}

main() {
	local -r script="${0##*/}"
	local -r version="2.3.26217"
	local -i exit_code=0
	check_package fzf
	unmount_usb
	exit_code "$?"
	over_line "$script $version"
	exit "$exit_code"
}

main "$@"
