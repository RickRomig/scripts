#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-bu.dh
# Description  : Incremental backups of Gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 26 Oct 2023
# Last updated : 07 Jan 2024 (Version 0.1.6)
# Comments     : Run as a daily cron job on the main system.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

## Global Variables ##

day=$(date +%a)
snar="gitea.snar"
sngz="gitea.sngz"
arc_date=$(date +'%y%m%d-%u')
archive="gitea.$arc_date.tar.gz"
arc_dir="$HOME/Downloads/archives/gitea-repo"

## Execution ##

# On Sunday, set up SNAR file for full backup & delete archives older than 3 months.
if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
	[[ -e "$arc_dir/$sngz" ]] && mv "$arc_dir/$sngz" "$arc_dir/$sngz.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +90 -delete
fi

# Incremental backup of Gitea repositories.
tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" gitea

# Copy archive to Gitea server.
rsync -a --delete "$HOME"/Downloads/archives/gitea-repo/ rick@192.168.0.16:Downloads/archives/gitea-repo/
exit