#!/usr/bin/env bash
##########################################################################
# Script Name  : passwdsync.sh
# Description  : syncs password database with copy in Dropbox
# Dependencies : none
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 Aug 2020
# Last updated : 21 Jul 2025
# Version      : 4.16.25202
# Comments     : run as a local daily cron job
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

set -euo pipefail

mstr_dir=$HOME"/Documents"
dbox_dir=$HOME"/Dropbox"
log_dir=$HOME"/.local/share/logs"
log_file="password-db.log"

# Create the log directory if it doesn't already exist
[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

{
  printf "%(%F|%R)T|"
  if [[ $(find "$mstr_dir/Passwords.kdbx" -newer "$dbox_dir/Passwords.kdbx" ) ]]; then
    cp -p "$mstr_dir"/Passwords*.kdbx "$dbox_dir/"
    printf "updated\n"
  else
    printf "unchanged\n"
  fi
} >> "$log_dir/$log_file"

# If more than 30 entries, remove the oldest entry
log_len=$(wc -l < "$log_dir/$log_file")
[[ "$log_len" -gt 30 ]] && sed -i '1d' "$log_dir/$log_file"

exit
