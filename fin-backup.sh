#!/usr/bin/env bash
##########################################################################
# Script Name  : fin-backup.sh
# Description  : Incremental backups of Finance & HomeBank directories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 28 Oct 2023
# Last updated : 17 Dec 2023 (Version 0.1.3)
# Comments     : Run as a daily cron job on the finance system
#              : Excludes ~/Documents/Finance/Archives directory
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Global Variables ##

dow=$(date +%u)
arc_date=$(date +%y%m%d)
day=$(date +%a)
snar="finance.snar"
archive="finance.$arc_date-$dow.tar.gz"
arc_dir="$HOME/Downloads/archives/finance"

## Execution ##

if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +85 -delete
fi

# tar -cpzf "$arc_dir/$archive" -g "$arc_dir/$snar" "$HOME"/Documents/Finance/CY2022 "$HOME"/Documents/Finance/CY2023 "$HOME"/Documents/HomeBank
tar --exclude='Archives' -cpzf "$arc_dir/$archive" -g "$arc_dir/$snar" "$HOME"/Documents/Finance "$HOME"/Documents/HomeBank

rsync -aq --delete "$HOME"/Downloads/archives/finance/ 192.168.0.10:Downloads/archives/finance/

exit