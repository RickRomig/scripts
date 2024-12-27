#!/usr/bin/env bash
##########################################################################
# Script Name  : journal-bu.sh
# Description  : Backup personal journals
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 11 Mar 2024
# Last updated : 27 Dec 2024
# Version      : 2.0.24362
# Comments     : Run as a local cron job.
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
	arc_dir="$HOME/Downloads/archives/journals"
	archive="journals.$(date +'%y%m%d-%u').tar.gz"
	snar="journal.snar"
	day=$(date +%a)
	[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"
	[[ "$day" == "Sun" ]] && sunday_actions "$arc_dir" "$snar"
	tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" Journals
	rsync -aq --delete "$HOME"/Downloads/archives/journals/ rick@192.168.0.11:/data/archives/journals/
	exit
}

## Execution ##

main "$@"
