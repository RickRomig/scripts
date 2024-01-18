#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-dwm-bu.sh
# Description  : daily, weekly, monthly snapshots of gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 17 Jan 2024
# Last updated : 18 Jan 2024 Version 1.0.2
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

arc_dir="$HOME/Downloads/archives/gitea"
archive="gitea-bu-$(date +%y%m%d).tar.gz"
dow=$(date +%a)
dom=$(date +%d)

daily_bu() {
	tar -zpcf "$arc_dir/daily/$archive" -C "$HOME" gitea
	find "$arc_dir/daily" -mtime +7 -delete
}

weekly_bu() {
	tar -zpcf "$arc_dir/weekly/$archive" -C "$HOME" gitea
	find "$arc_dir/weekly" -mtime +31 -delete
}

monthly_bu() {
	tar -zpcf "$arc_dir/monthly/$archive" -C "$HOME" gitea
	find "$arc_dir/monthly" -mtime +365 -delete
}

# Create archive directories if they don't exist
[[ -d "$arc_dir/daily" ]] || mkdir -p "$arc_dir/daily"
[[ -d "$arc_dir/weekly" ]] || mkdir -p "$arc_dir/weekly"
[[ -d "$arc_dir/monthly" ]] || mkdir -p "$arc_dir/monthly"

# Snapshots
daily_bu
[[ "$dow" == "Sun" ]] && weekly_bu
[[ "$dom" -eq 1 ]] && monthly_bu

# Sync archives to Gitea server
rsync -a --delete "$HOME"/Downloads/archives/gitea/ rick@192.168.0.16:Downloads/archives/gitea/

exit
