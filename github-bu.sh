#!/usr/bin/env bash
##########################################################################
# Script Name  : github-bu.sh
# Description  : Incremental backups of Projects repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 26 Oct 2023
# Last updated : 15 Nov 2023 (Version 0.1.4)
# Comments     : Run as a daily cron job
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Global Variables ##

dow=$(date +%u)
arc_date=$(date +%y%m%d)
day=$(date +%a)
snar="projects.sngz"
archive="projects.$arc_date-$dow.tar.gz"
arc_dir="$HOME/Downloads/archives/projects-repo"

## Execution ##

if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +85 -delete
fi

tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" Projects

rsync -aq --delete "$HOME"/Downloads/archives/projects-repo/ rick@192.168.0.16:Downloads/archives/projects-repo/

exit