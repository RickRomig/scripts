#!/usr/bin/env bash
##########################################################################
# Script Name  : checkinit.sh
# Description  : Checks what init system is being used.
# Dependencies : None
# Arguments    : None
# Author       : Copyright (C) 2022, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 07 Sep 2022
# Updated      : 06 Sep 2026
# Version      : 2.2.26249
# Comments     :
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

get_init() {
	if [[ $(cat /proc/1/comm) == "systemd" ]] ; then
		echo "SystemD"
	elif [[ $(awk '{print $1}' < <(/sbin/init --version 2>/dev/null)) == "SysV" ]]; then
		echo "SysV"
	elif [[ $(cat /proc/1/comm) == "runit" ]] ; then
		echo "Runit"
	elif [[ -f /sbin/openrc ]]; then
		echo "OpenRC"
	elif grep -q 'upstart' < <(/sbin/init --version 2>/dev/null); then
		echo "Upstart"
	else
		echo "Undetermined"
	fi
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="2.2.26218"
	local -r short_line="---"
	printf "Init System: %s\n" "$(get_init)"
	printf "%s\n%s %s\n" "$short_line" "$script" "$version"
	exit
}

main "$@"
