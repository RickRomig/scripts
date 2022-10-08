#!/usr/bin/env sh
#############################################################################
# Script Name  : scriptarchive.sh
# Description  : Makes a dated archive of shell scripts in ~/bin
# Dependencies : sed, zip
# Arguments    : None
# Author       : Copyright (C) Richard B. Romig, 20 Jan 2020
# Email        : rick.romig@gmail.com
# Comments     : Includes functions subdirectory
#              : Schedule with user's crontab from ~/bin, ~/.local/bin or ~/opt/bin
# Last updated : version 0.2.12, 08 Oct 2022
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
log_date=$(date '+%a|%F|%R')
err_log="error.log"

## Execution ##

# Create archive and log directories if they don't exist
[ -d "$arc_dir" ] || mkdir -p "$arc_dir"
[ -d "$log_dir" ] || mkdir -p "$log_dir"

# Create archive of the ~/bin directory and write results to log file
rm -f "$arc_dir"/Script\ Archive* > /dev/null 2>&1
{
  printf "%s|" "$log_date"
  if /usr/bin/zip -rq "$arc_dir/$archive" "$src_dir" 2> "$arc_dir/$err_log"; then
    printf "successful\\n"
    touch "$arc_dir/Script Archive successful - $(date +%F)"
  else
    printf "had errors\\n"
    touch "$arc_dir/Script Archive had errors - $(date +%F)"
  fi
} >> "$log_dir/$log_file"

## Clean up ##

# Remove oldest log entry if more than 30 entries
log_len=$(wc -l "$log_dir/$log_file" | cut -d' ' -f1)
[ "$log_len" -gt 30 ] && sed -i '1d' "$log_dir/$log_file"
# Remove archives older than one and a half years.
find "$arc_dir"/ -maxdepth 1 -type f -name "*.zip" -mtime +550 -exec rm {} +

exit
