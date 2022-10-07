#!/usr/bin/env sh
#############################################################################
# Script Name  : passwdsync.sh
# Description  : syncs password databases with Dropbox folder
# Dependencies : none
# Arguments    : none
# Author       : Richard B. Romig, 19 August 2020
# Email        : rick.romig@gmail.com
# Comments     : run as a local daily cron job
# Version      : 0.4.4, updated 31 Jul 2022
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
#############################################################################
set -e

mstr_dir=$HOME"/Documents/mosfanet"
dbox_dir=$HOME"/Dropbox"
log_dir=$HOME"/.local/share/logs"
log_file="password-db.log"

# Create the log directory if it doesn't already exist
[ -d "$log_dir" ] || mkdir -p "$log_dir"

{
  printf "%s|" "$(date '+%F|%R')"
  if [ "$dbox_dir/Rick_pwds.psafe3" -ot "$mstr_dir/Rick_pwds.psafe3" ]; then
    cp -p "$mstr_dir/Rick_pwds.psafe3" "$mstr_dir/Rick_pwds.bak" "$dbox_dir/"
    printf "%s" "updated"
  else
    printf "%s" "unchanged"
  fi
  printf "|"
  if [ "$dbox_dir/Passwords.kdbx" -ot "$mstr_dir/Passwords.kdbx" ]; then
    cp -p "$mstr_dir/Passwords.kdbx" "$mstr_dir/Passwords.old.kdbx" "$dbox_dir/"
    printf "updated\n"
  else
    printf "unchanged\n"
  fi
} >> "$log_dir/$log_file"

# If more than 30 entries, remove the oldest entry

log_len=$(wc -l "$log_dir/$log_file" | cut -d' ' -f1)
[ "$log_len" -gt 30 ] && sed -i '1d' "$log_dir/$log_file"

exit
