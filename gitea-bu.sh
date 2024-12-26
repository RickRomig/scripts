#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-bu.dh
# Description  : Incremental backups of Gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 26 Oct 2023
# Last updated : 25 Dec 2024 (Version 2.0.24360)
# Comments     : Run as a daily cron job on the main system.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -eu

## Functions ##

sunday_actions() {
	local arc_dir="$1"
	local snar="$2"
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
	find "$arc_dir" -mtime +91 -delete
}

main() {
	local arc_dir archive day snar
	arc_dir="$HOME/Downloads/archives/gitea-repo"
	archive="gitea.$(date +'%y%m%d-%u').tar.gz"
	snar="gitea.snar"
	day=$(date +%a)
	[[ "$day" == "Sun" ]] && sunday_actions "$arc_dir" "$snar"
	tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" gitea
	exit
}

## Execution ##

main "$@"
