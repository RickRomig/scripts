#!/usr/bin/env bash
###############################################################################
# Script Name  : hb-archive.sh
# Description  : Create HomeBank archive of *.bak files as a monthly cron job.
# Dependencies : zip
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig, 21 January 2020
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Version      : 4.0.254039
# Last updated : 08 Feb 2025
# Comments     : Run from user's crontab to run on the 1st of the month
#              : to archive 2nd month previous. (1 May archives March files)
# License      : GNU General Public License, version 2.0
###############################################################################

set -eu

# Functions

trim_log() {
	local log_len log_dir log_file
	log_dir="$1"
	log_file="$2"
	log_len=$(wc -l "$log_dir/$log_file" | cut -d " " -f1)
	[[ "$log_len" -gt 36 ]] && sed -i '1d' "$log_dir/$log_file"
}

del_old() {
	local arc_dir="$1"
	find "$arc_dir" -daystart -mtime +1095 -exec rm {} +
}

archive_bak() {
	local arc_date arc_dir err_log hb_dir log_date log_dir log_file ref_date status
	arc_dir="$1"
	log_dir="$2"
	log_file="$3"
	log_date=$(date '+%a|%F|%R')
	arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)
	ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y)
	archive="$arc_date-backup.zip"
	hb_dir="$HOME/Documents/HomeBank"
	err_log="HomeBank-error.log"
	status=0

	{
	  printf "%s|%s|" "$log_date" "$arc_date"
	  if zip -qmtt "$ref_date" "$arc_dir/$archive" "$hb_dir"/*.bak 2> "$arc_dir/$err_log"
	  then
	    printf "successful\n"
	    echo "$(date +%F) - HomeBank Archive successful." > "$arc_dir/$err_log"
	  else
	    status="$?"
	    printf "had errors\n"
	    echo "$(date +%F) - HomeBank Archive had errors. ($status)" >> "$arc_dir/$err_log"
	  fi
	} >> "$log_dir/$log_file"
}

main() {
	local arc_dir log_dir log_file
	arc_dir="$HOME/Downloads/archives/homebank"
	log_dir="$HOME/.local/share/logs"
	log_file="HomeBank-archive.log"

	# Create directories if they don't exist.
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
	[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"

	# Backup *.bak files from from 2 months previous.
	archive_bak "$arc_dir" "$log_dir" "$log_file"
	# Trim top entry from the log file when the length exceeds 36 entries.
	trim_log "$log_dir" "$log_file"
	# Delete archive files older than 3 years.
	del_old "$arc_dir"
	exit
}

# Execution

main "$@"
