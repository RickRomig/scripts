#!/usr/bin/env bash
##########################################################################
# Script Name  : hb-archive.sh
# Description  : Create HomeBank archive of *.bak files as a monthly cron job.
# Dependencies : zip
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig, 21 January 2020
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Last updated : 09 Oct 2025
# Version      : 5.0.25282
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

# Trim top entry from the log file when the length exceeds 12 entries.
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
	local arc_date arc_dir err_log hb_dir log_dir log_file ref_date status
	arc_dir=~/Downloads/archives/homebank
	log_dir=~/.local/share/logs
	log_file="HomeBank-archive.log"
	arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)
	ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y)
	archive="$arc_date-backup.zip"
	hb_dir=~/Documents/HomeBank
	err_log="HomeBank-error.log"
	status=0
	# Create directories if they don't exist.
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
	[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"
{
	  printf "%(%a|%F|%R)T|%s|" -1 "$arc_date"
		if zip -qmtt "$ref_date" "$arc_dir/$archive" "$hb_dir"/*.bak 2> "$arc_dir/$err_log"; then
	    printf "successful\n"
	    printf "%(%F)T - HomeBank Archive successful.\n" > "$arc_dir/$err_log"
	  else
	    status="$?"
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
