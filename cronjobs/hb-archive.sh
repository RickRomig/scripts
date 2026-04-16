#!/usr/bin/env bash
##########################################################################
# Script Name  : hb-archive.sh
# Description  : Create HomeBank archive of *.bak files as a monthly cron job.
# Dependencies : zip
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig, 21 January 2020
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Last updated : 16 Apr 2026
# Version      : 5.1.26106
# Comments     : Run from user's crontab to run on the 1st of the month
#              : to archive 2nd month previous. (1 May archives March files)
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

# If log files contains more than 12 entries, trim top entry.
trim_log() {
	local log_len log_dir log_file
	log_dir="$1"
	log_file="$2"
	log_len=$(wc -l < "$log_dir/$log_file")
	[[ "$log_len" -gt 12 ]] && sed -i '1d' "$log_dir/$log_file"
}

# Delete archive files older than 3 years.
del_old_archives() {
	local arc_dir="$1"
	find "$arc_dir" -daystart -mtime +1095 -exec rm {} +
}

# Backup *.bak files from from 2 months previous.
archive_bak() {
	local arc_date ref_date
	arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)
	ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y)
	local -r arc_dir=~/Downloads/archives/homebank
	local -r log_dir=~/.local/share/logs
	local -r log_file="HomeBank-archive.log"
	local -r archive="$arc_date-backup.zip"
	local -r hb_dir=~/Documents/HomeBank
	local -r err_log="HomeBank-error.log"
	local status=0
	# Create directories if they don't exist.
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
	[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"
{
	  printf "%(%a|%F|%R)T|%s|" -1 "$arc_date"
		zip -qmtt "$ref_date" "$arc_dir/$archive" "$hb_dir"/*.bak 2> "$arc_dir/$err_log"; status="$?"
		if [[ $status -eq 0 ]]; then
	    printf "successful\n"
	    printf "%(%F)T - HomeBank Archive successful.\n" > "$arc_dir/$err_log"
	  else
	    printf "had errors\n"
	    printf "%(%F)T - HomeBank Archive had errors. (%s)" -1 "$status" >> "$arc_dir/$err_log"
	  fi
	} >> "$log_dir/$log_file"
	trim_log "$log_dir" "$log_file"
	del_old_archives "$arc_dir"
}

main() {
	archive_bak
	exit
}

main "$@"
