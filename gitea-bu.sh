#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-bu.dh
# Description  : Incremental backups of Gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 26 Oct 2023
# Last updated : 24 Dec 2024 (Version 1.10.24359)
# Comments     : Run as a daily cron job on the main system.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -eu

## Global Variables ##

day=$(date +%a)
snar="gitea.snar"
arc_date=$(date +'%y%m%d-%u')
archive="gitea.$arc_date.tar.gz"
arc_dir="$HOME/Downloads/archives/gitea-repo"

## Execution ##

# On Sunday,rename SNAR file for full backup & delete archives older than 3 months.
if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +91 -delete
fi

# Incremental backup of Gitea repositories.
tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" gitea

exit
