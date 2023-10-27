#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-bu.dh
# Description  : Incremental backups of Gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 26 Oct 2023
# Last updated : 27 Oct 2023 (Version 0.1.2)
# Comments     : Run as a daily cron job
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Global Variables ##

dow=$(date +%u)
arc_date=$(date +%y%m%d)
day=$(date +%a)
snar="gitea.sngz"
archive="gitea.$arc_date-$dow.tar.gz"
arc_dir="$HOME/Downloads/archives/gitea-repo"

## Execution ##

if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +85 -delete
fi

tar -czg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" gitea

rsync -a --delete "$HOME"/Downloads/archives/gitea-repo/ rick@192.168.0.16:Downloads/archives/gitea-repo/

# exit