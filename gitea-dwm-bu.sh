#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-dwm-bu.sh
# Description  : daily, weekly, monthly backup of gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 17 Jan 2024
# Last updated : 17 Jan 2024 Version 1.0.0
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

arc_dir="$HOME/Work/shell/backup/gitea"
archive="gitea-bu-$(date +%y%m%d).tar.gz"
dow=$(date +%u)
dom=$(date +%d)

# Create archive directories if they don't exist
[[ -d "$arc_dir/daily" ]] || mkdir -p "$arc_dir/daily"
[[ -d "$arc_dir/weekly" ]] || mkdir -p "$arc_dir/weekly"
[[ -d "$arc_dir/monthly" ]] || mkdir -p "$arc_dir/monthly"

# Daily archive
tar -zpcf "$arc_dir/daily/$archive" -C "$HOME" gitea
find "$arc_dir/daily" -mtime +7 -delete

# Weekly archive
if [[ "$dow" -eq 0 || "$dow" -eq 7 ]]; then
	tar -zpcf "$arc_dir/weekly/$archive" -C "$HOME" gitea
	find "$arc_dir/weekly" -mtime +31 -delete
fi

# Monthly archive
if [[ "$dom" -eq 1 ]]; then
	tar -zpcf "$arc_dir/monthly/$archive" -C "$HOME" gitea
	find "$arc_dir/monthly" -mtime +365 -delete
fi

# Sync archives to Gitea server
rsync -a --delete "$HOME"/Downloads/archives/gitea/ rick@192.168.0.16:Downloads/archives/gitea/

exit
