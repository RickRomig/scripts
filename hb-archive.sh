#!/usr/bin/env bash
###############################################################################
# Script Name  : hb-archive.sh
# Description  : Create HomeBank archive of *.bak files as a monthly cron job.
# Dependencies : zip
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig, 21 January 2020
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Version      : 3.7.24287
# Last updated : 13 Oct 2024
# Comments     : Run from user's crontab to run on the 1st of the month
#              : to archive 2nd month previous. (1 May archives March files)
# License      : GNU General Public License, version 2.0
###############################################################################

set -euo pipefail

# Variables
ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y)
arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)
log_date=$(date '+%a|%F|%R')
arc_dir=$HOME"/Downloads/archives/homebank"
hb_dir=$HOME"/Documents/HomeBank"
log_dir=$HOME"/.local/share/logs"
archive="$arc_date-backup.zip"
log_file="HomeBank-archive.log"
err_log="HomeBank-error.log"

# Execution

# Create log and archive directories if they don't already exist
[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"

# Archive the .bak files for the 2nd month prior & write success/failure to log.
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

# Trim top entry from the log file when the length exceeds 36 entries.
log_len=$(wc -l "$log_dir/$log_file" | cut -d " " -f1)
[[ "$log_len" -gt 36 ]] && sed -i '1d' "$log_dir/$log_file"

# Delete archive files older than 3 years
find "$arc_dir" -mtime +1095 -exec rm {} +

# Sync HomeBank archive with archive copy on the main system
rsync -aq --delete "$HOME"/Downloads/archives/homebank/ 192.168.0.10:Downloads/archives/homebank/

exit
