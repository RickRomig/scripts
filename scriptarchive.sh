#!/usr/bin/env bash
#############################################################################
# Script Name  : scriptarchive.sh
# Description  : Makes a dated tarball archive of shell scripts in ~/bin
# Dependencies : None
# Arguments    : None
# Author       : Copyright (C) 2020 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 20 Jan 2020
# Updated      : 28 Feb 2025 (version 3.1.25059)
# Comments     : Includes all subdirectories
#              : Schedule with user's crontab from ~/.local/bin
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
#############################################################################

set -eu

## Variables ##

archive="$(date +%y%m%d)-scripts.tar.gz"
arc_dir=$HOME"/Downloads/archives/scripts"
log_dir=$HOME"/.local/share/logs"
log_file="script-archive.log"
err_log="error.log"

## Execution ##

# Create archive and log directories if they don't exist
[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"
[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
[[ -f "$arc_dir/$err_log" ]] && rm -f "$arc_dir/$err_log" >/dev/null 2>&1

# Create archive of the ~/bin directory and write results to log file
{
  printf "%s|" "$(date '+%a|%F|%R')"
  if /usr/bin/tar --exclude='.git' -hcpzf "$arc_dir/$archive" -C "$HOME" bin 2> "$arc_dir/$err_log"; then
    printf "successful\n"
    echo "Script Archive successful - $(date +%F)" >> "$arc_dir/$err_log"
  else
    printf "had errors\n"
    echo "Script Archive had errors - $(date +%F)" >> "$arc_dir/$err_log"
  fi
} >> "$log_dir/$log_file"

## Clean up and exit ##

# Remove oldest log entry if more than 30 entries
log_len=$(wc -l < "$log_dir/$log_file")
[[ "$log_len" -gt 30 ]] && sed -i '1d' "$log_dir/$log_file"
# Remove archives older than two years (730 days).
find "$arc_dir"/ -maxdepth 1 -type f -mtime +730 -exec rm {} +
exit
