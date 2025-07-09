#!/usr/bin/env bash
#############################################################################
# Script Name  : passwdsync.sh
# Description  : syncs password database with copy in Dropbox
# Dependencies : none
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 Aug 2020
# Last updated : 08 Jul 2025
# Version      : 4.16.25189
# Comments     : run as a local daily cron job
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
#############################################################################

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
