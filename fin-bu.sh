#!/usr/bin/env bash
##########################################################################
# Script Name  : fin-bu.sh
# Description  : Incremental backups of Finance & HomeBank directories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Oct 2023
# Last updated : 23 Nov 2024 (Version 1.7.24328)
# Comments     : Run as a daily cron job
#              : Excludes ~/Documents/Finance/Archives directory
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Global Variables ##

day=$(date +%a)
snar="finance.snar"
arc_date=$(date +'%y%m%d-%u')
archive="finance.$arc_date.tar.gz"
arc_dir="$HOME/Downloads/archives/finance"

## Execution ##

# On Sunday, set up SNAR file for full backup & delete archives older than 3 months.
if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +91 -delete
fi

# Incremental backup of Finance and HomeBank directories.
tar --exclude='Archives' -cpzf "$arc_dir/$archive" -g "$arc_dir/$snar" "$HOME"/Documents/Finance "$HOME"/Documents/HomeBank

exit