#!/usr/bin/env sh
###############################################################################
# Script Name  : hb-archive.sh
# Description  : Create HomeBank archive as a cron job.
# Dependencies : zip
# Arguments    : none
# Author       : Richard B. Romig, 21 January 2020
# Email        : rick.romig@gmail.com
# Version      : Version 1.2.12,
# Last updated : 20 Jul 2022
# Comments     : Run from user's crontab to run on the 1st of the month
#              : to archive 2nd month previous. (1 May archives March)
# License      : GNU General Public License, version 2.0
###############################################################################

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

# Create log and archive directories if they don't already exist
[ -d "$log_dir" ] || mkdir -p "$log_dir"
[ -d "$arc_dir" ] || mkdir -p "$arc_dir"

# Remove flag file from archive directory.
rm -f "$arc_dir"/HomeBank\ Archive* > /dev/null 2>&1

# Archive the .bak files for the 2nd month prior & write success/failure to log.
{
  printf "%s|%s|" "$log_date" "$arc_date"
  if zip -qmtt "$ref_date" "$arc_dir/$archive" "$hb_dir"/*.bak 2> "$arc_dir/$err_log"
  then
    printf "successful\n"
    touch "$arc_dir/HomeBank Archive successful ($(date +%F))"
  else
    printf "had errors\n"
    touch "$arc_dir/HomeBank Archive had errors ($(date +%F))"
  fi
} >> "$log_dir/$log_file"

# Trim top entry from the log file when the length exceeds 36 entries.
log_len=$(wc -l "$log_dir/$log_file" | cut -d " " -f1)
[ "$log_len" -gt 36 ] && sed -i '1d' "$log_dir/$log_file"

exit
