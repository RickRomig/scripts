#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-dwm-bu.sh
# Description  : daily, weekly, monthly snapshots of git repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 17 Jan 2024
# Last updated : 24 Dec 2024 Version 1.4.24359
# Comments     : Includes both Gitea and GitHub repositories.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -eu

arc_dir="$HOME/Downloads/archives/gitea"
archive="gitea-bu-$(date +%y%m%d).tar.gz"
dow=$(date +%a)		# day of week (Sun - Sat)
dom=$(date +%d)		# day of month (1-31)

daily_bu() {
	tar -zpcf "$arc_dir/daily/$archive" "$HOME"/gitea "$HOME"/Projects
	find "$arc_dir/daily" -mtime +7 -delete
}

weekly_bu() {
	tar -zpcf "$arc_dir/weekly/$archive" "$HOME"/gitea "$HOME"/Projects
	find "$arc_dir/weekly" -mtime +31 -delete
}

monthly_bu() {
	tar -zpcf "$arc_dir/monthly/$archive" "$HOME"/gitea "$HOME"/Projects
	find "$arc_dir/monthly" -mtime +365 -delete
}

# Create archive directories if they don't exist
[[ -d "$arc_dir" ]] || mkdir -p "$arc_dir"/{daily,weekly,monthly}

# Snapshot schedule
daily_bu
[[ "$dow" == "Sun" ]] && weekly_bu
[[ "$dom" -eq 1 ]] && monthly_bu

exit
