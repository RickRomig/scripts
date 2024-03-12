#!/usr/bin/env bash
##########################################################################
# Script Name  : journal-bu.sh
# Description  : Backup personal journals
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 11 Mar 2024
# Last updated : 12 Mar 2024
# Version      : 0.1.0
# Comments     : Run as a local cron job.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

## Global Variables ##

day=$(date +%a)
arc_date=$(date +'%y%m%d-%u')
arc_dir="$HOME/Downloads/archives/journals"
archive="journals.$arc_date.tar.gz"
snar="journal.snar"

## Execution ##

[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"

# On Sunday, rename previous snar file and delete archives older than 3 monthss (13 weeks)
if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +91 -delete
fi

# Full/Incremental backup of personal journals (excludes locked files)
tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" --exclude='.~lock*' -C "$HOME/Documents" Journals

# Copy archive to HP-6005
rsync -aq --delete "$HOME"/Downloads/archives/journals/ rick@192.168.0.11:/data/archives/journals/
exit
