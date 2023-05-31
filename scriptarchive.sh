#!/usr/bin/env sh
#############################################################################
# Script Name  : scriptarchive.sh
# Description  : Makes a dated archive of shell scripts in ~/bin
# Dependencies : zip
# Arguments    : None
# Author       : Copyright (C) 2020 Richard B. Romig, 20 Jan 2020
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Comments     : Includes all subdirectories
#              : Schedule with user's crontab from ~/.local/bin
# Last updated : version 0.2.17, 31 May 2023
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
#############################################################################
set -e

## Variables ##

src_dir=$HOME"/bin"
archive="$(date +%y%m%d-scripts)"
arc_dir=$HOME"/Downloads/archives/scripts"
log_dir=$HOME"/.local/share/logs"
log_file="script-archive.log"
err_log="error.log"

## Execution ##

# Create archive and log directories if they don't exist
[ -d "$arc_dir" ] || mkdir -p "$arc_dir"
[ -d "$log_dir" ] || mkdir -p "$log_dir"

# Create archive of the ~/bin directory and write results to log file
rm -f "$arc_dir"/Script\ Archive* > /dev/null 2>&1
{
  printf "%s|" "$(date '+%a|%F|%R')"
  if /usr/bin/zip -rq "$arc_dir/$archive" "$src_dir" -x "$src_dir/.git/*" 2> "$arc_dir/$err_log"; then
    printf "successful\n"
    touch "$arc_dir/Script Archive successful - $(date +%F)"
  else
    printf "had errors\n"
    touch "$arc_dir/Script Archive had errors - $(date +%F)"
  fi
} >> "$log_dir/$log_file"

## Clean up ##

# Remove oldest log entry if more than 30 entries
log_len=$(wc -l "$log_dir/$log_file" | cut -d' ' -f1)
[ "$log_len" -gt 30 ] && sed -i '1d' "$log_dir/$log_file"
# Remove archives older than one and a half years (550 days).
find "$arc_dir"/ -maxdepth 1 -type f -name "*.zip" -mtime +550 -exec rm {} +
# Removes empty error log
[ -s "$arc_dir/$err_log" ] || rm -f "$arc_dir/$err_log"
exit
