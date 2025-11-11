#!/usr/bin/env bash
##########################################################################
# Script Name  : checkinit.sh
# Description  : Checks what init system is being used.
# Dependencies : None
# Arguments    : None
# Author       : Copyright (C) 2022, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 07 Sep 2022
# Updated      : 10 Nov 2025
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

## Functions ##

get_init() {
	if [[ $(cat /proc/1/comm) == "systemd" ]] ; then
		echo "SystemD"
	elif [[ $(/sbin/init --version 2>/dev/null | awk '{print $1}') == "SysV" ]]; then
		echo "SysV"
	elif [[ $(cat /proc/1/comm) == "runit" ]] ; then
		echo "Runit"
	elif [[ -f /sbin/openrc ]]; then
		echo "OpenRC"
	elif /sbin/init --version 2>/dev/null | grep -q 'upstart'; then
		echo "Upstart"
	else
		echo "Undetermined"
  fi
}

main() {
	local -r script="${0##*/}"
	local -r version="2.0.25314"
	local -r short_line="---"
	printf "Init System: %s\n" "$(get_init)"
	printf "%s\n%s %s\n" "$short_line" "$script" "$version"
	exit
}

## Execution ##

main "$@"
