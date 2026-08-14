#!/usr/bin/env bash
###############################################################################
# Script Name  : firmware-update.sh
# Description  : Update firmware
# Dependencies : fwupd
# Arguments    : None
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 22 Jul 2026
# Last updated : 14 Aug 2026
# Version      : 1.1.26226
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2
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

update_firmware() {
	# Check if in UEFI mode
	# if test -d /sys/firmware/efi; then
	if [[ -d /sys/firmware/efi ]]; then
		printf "UEFI OK\n"
	else
		printf "Legacy - fwupd will not flash\n"
		return "$E_UNSUPPORTED"
	fi
	# Check for available updates
	sudo_login 1
	sudo fwupdmgr get-updates
	# Refresh LVFS metadata
	sudo fwupdmgr refresh --force
	# Apply updates
	sudo fwupdmgr update && verify_update
	return "$?"
}

verify_update() {
	sudo dmidecode -s bios-version
	sudo fwupdmgr get-updates
	return "$?"
}

main() {
	local -r script="${0##*/}"
	local -r version="1.1.26226"
	local -i exit_code=0
	check_package fwupd
	update_firmware
	exit_code="$?"
	over_line "$script $version"
	exit "$exit_code"
}

main "$@"
