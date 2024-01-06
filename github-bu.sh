#!/usr/bin/env bash
##########################################################################
# Script Name  : github-bu.sh
# Description  : Incremental backups of Projects repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 26 Oct 2023
# Last updated : 05 Jan 2024 (Version 0.1.6)
# Comments     : Run as a daily cron job on the main system.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

## Global Variables ##

day=$(date +%a)
snar="projects.sngz"
arc_date=$(date +'%y%m%d-%u')
archive="projects.$arc_date.tar.gz"
arc_dir="$HOME/Downloads/archives/projects-repo"

## Execution ##

# On Sunday, set up SNAR file for full backup & delete archives older than 3 months.
if [[ "$day" == "Sun" ]]; then
	[[ -e "$arc_dir/$snar" ]] && mv "$arc_dir/$snar" "$arc_dir/$snar.$(date --date '7 days ago' +%y%m%d)"
  find "$arc_dir" -mtime +60 -delete
fi

# Incremental backup of GitHbe repositories (Projects directory).
tar -cpzg "$arc_dir/$snar" -f "$arc_dir/$archive" -C "$HOME" Projects

# Copy archive to Gitea server.
rsync -aq --delete "$HOME"/Downloads/archives/projects-repo/ rick@192.168.0.16:Downloads/archives/projects-repo/
exit