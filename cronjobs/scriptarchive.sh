#!/usr/bin/env bash
##########################################################################
# Script Name  : scriptarchive.sh
# Description  : Makes a dated tarball archive of shell scripts in ~/bin
# Dependencies : None
# Arguments    : None
# Author       : Copyright (C) 2020 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 20 Jan 2020
# Updated      : 31 Jul 2025
# Version      : 4.2.25211
# Comments     : Includes all subdirectories in ~/bin
#              : Schedule with user's crontab from ~/.local/bin
# TODO (Rick)  :
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

archive_scripts() {
  local arc_dir="$1"
  local log_dir="$2"
  local log_file="$3"
  local -r err_log="error.log"
  local archive
  archive="$(date +%y%m%d)-scripts.tar.gz"
  # Create archive and log directories if they don't exist
  [[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"
  [[ -d "$log_dir" ]] || mkdir -p "$log_dir"
  # Remove old error log
  [[ -f "$arc_dir/$err_log" ]] && rm -f "$arc_dir/$err_log" >/dev/null 2>&1
  # Create archive of the ~/bin directory and write results to log file
  {
    printf "%(%a|%F|%R)T|"
    if /usr/bin/tar --exclude='.git' -hcpzf "$arc_dir/$archive" -C "$HOME" bin 2> "$arc_dir/$err_log"; then
      printf "successful\n"
      printf "Script Archive successful - %(%F)T\n" >> "$arc_dir/$err_log"
    else
      printf "had errors\n"
      printf "Script Archive had errors  - %(%F)T\n" >> "$arc_dir/$err_log"
    fi
  } >> "$log_dir/$log_file" 2> "$arc_dir/$err_log"
}

cleanup() {
  local arc_dir="$1"
  local log_dir="$2"
  local log_file="$3"
  local log_len
  # Remove oldest log entry if more than 30 entries
  log_len=$(wc -l < "$log_dir/$log_file")
  [[ "$log_len" -gt 30 ]] && sed -i '1d' "$log_dir/$log_file"
  # Remove archives older than two years (730 days).
  find "$arc_dir"/ -maxdepth 1 -type f -mtime +730 -exec rm {} +
}

main() {
  local -r arc_dir="$HOME/Downloads/archives/scripts"
  local -r log_dir="$HOME/.local/share/logs"
  local -r log_file="script-archive.log"
  archive_scripts "$arc_dir" "$log_dir" "$log_file"
  cleanup "$arc_dir" "$log_dir" "$log_file"
  exit
}

main "$@"