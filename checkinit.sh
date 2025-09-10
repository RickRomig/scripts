#!/usr/bin/env bash
##########################################################################
# Script Name  : checkinit.sh
# Description  : Checks what init system is being used.
# Dependencies : None
# Arguments    : None
# Author       : Copyright (C) 2022, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 07 Sep 2022
# Updated      : 10 Sep 2025
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
	local  init_sys
	if [[ $(cat /proc/1/comm) == "systemd" ]] ; then
		init_sys="SystemD"
	elif [[ $(/sbin/init --version 2>/dev/null | awk '{print $1}') == "SysV" ]]; then
		init_sys="SysV"
	elif [[ $(cat /proc/1/comm) == "runit" ]] ; then
		init_sys="Runit"
	elif [[ -f /sbin/openrc ]]; then
		init_sys="OpenRC"
	elif /sbin/init --version 2>/dev/null | grep -q 'upstart'; then
		init_sys="Upstart"
	else
		init_sys="Undetermined"
  fi
	printf "%s" "$init_sys"
}

main() {
	local -r script="${0##*/}"
	local -r version="2.0.25253"
	local -r short_line="---"
	printf "Init System: %s\n" "$(get_init)"
	printf "%s\n%s %s\n" "$short_line" "$script" "$version"
	exit
}

## Execution ##

main "$@"
