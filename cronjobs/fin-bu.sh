#!/usr/bin/env bash
##########################################################################
# Script Name  : fin-bu.sh
# Description  : Incremental backups of Finance & HomeBank directories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Oct 2023
# Last updated : 09 Oct 2025
# Version      : 2.5.25282
# Comments     : Run as a local daily cron job
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

monday_actions() {
	local arc_dir="$1"
	local snar="$2"
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
	find "$arc_dir" -mtime +91 -delete
}

main() {
	local arc_dir archive day snar
	arc_dir=~/Downloads/archives/finance
	archive="finance.$(date +'%y%m%d-%u').tar.gz"
	snar="finance.snar"
	day=$(date +%a)
	[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"
	[[ "$day" == "Mon" ]] && monday_actions "$arc_dir" "$snar"
	tar -cpzf "$arc_dir/$archive" -g "$arc_dir/$snar" ~/Documents/Finance ~/Documents/HomeBank
	exit
}

## Execution ##

main "$@"
