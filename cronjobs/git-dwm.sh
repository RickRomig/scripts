#!/usr/bin/env bash
##########################################################################
# Script Name  : git-dwm.sh
# Description  : daily, weekly, monthly snapshots of git repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 17 Jan 2024
# Last updated : 18 Jan 2026
# Version      : 2.3.26018
# Comments     : Includes both Gitea and GitHub repositories.
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

create_snapshot() {
	local archive
	local interval="$1"
	local -r archive_dir=~/Downloads/archives/gitea
	archive="git-snapshot-$(date +%y%m%d).tar.gz"
	[[ -d "$archive_dir/$interval" ]] || mkdir -p "$archive_dir/$interval"
	case "$interval" in
		daily )
			tar -czpf "$archive_dir/$interval/$archive" "$HOME"/gitea "$HOME"/Projects >/dev/null 2>&1 ;;
		weekly|monthly )
			cp "$archive_dir/daily/$archive" "$archive_dir/$interval/"
	esac
	remove_old_snapshots "$interval" "$archive_dir"
}

remove_old_snapshots() {
	local interval="$1"
	local archive_dir="$2"
	case "$interval" in
		daily )
			find "$archive_dir/$interval" -daystart -mtime +6 -delete ;;
		weekly )
			find "$archive_dir/$interval" -daystart -mtime +28 -delete ;;
		monthly )
			find "$archive_dir/$interval" -daystart -mtime +364 -delete
	esac
}

main() {
	local dom dow
	dow=$(date +%a)		# day of week (Sun - Sat)
	dom=$(date +%d)		# day of month (01-31)
	create_snapshot "daily"
	[[ "$dow" == "Sun" ]] && create_snapshot "weekly"
	[[ "$dom" == "01" ]] && create_snapshot "monthly"
	exit
}

main "$@"
