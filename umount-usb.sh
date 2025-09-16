#! /usr/bin/env bash
##########################################################################
# Script Name  : umount-usb.sh
# Description  : script to unmount a USB drive in the /media/<user> directory
# Dependencies : fzf
# Arguments    : none
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 12 Mar 2025
# Last updated : 16 Sep 2025
# Version      : 1.2.25259
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

user=$(whoami)
usb_drive=$(find /media/"$user" -maxdepth 1 -type d -user "$user" | fzf --height 40% --reverse --prompt "Select the USB drive to unmount: ")

umount -l "$usb_drive"
printf "%s unmounted.\n" "$usb_drive"
[[ -d "$usb_drive" ]] && rmdir "$usb_drive"
exit
