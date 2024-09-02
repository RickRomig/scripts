#!/usr/bin/env bash
###############################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : trash-cli tree 'sudo apt install trash-cli tree'
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Last updated : 02 Sep 2024 Version 2.5.24246
# Comments     : Run as a user cron job.
#              : Trash directory does not exist until a file is moved to the trash.
#              : Tested with Debian 11/12, LMDE 6, Mint 21.x, Mint 22, MX Linux 23.1, BunsenLabs 11.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

readonly trash_dir="$HOME/.local/share/Trash"
readonly log_dir="$HOME/.local/share/logs"
readonly log_file="trash.log"

empty_trash() {
	if [[ $(find "$trash_dir"/info -type f | wc -l) -gt 0 ]]; then
		printf "\nTrash contents:\n---------------\n"
		tree -a "$trash_dir"
		if [[ -x usr/bin/trash-empty ]]; then
			/usr/bin/trash-empty
		else
			find "$trash_dir"/files -mindepth 1 -type f,d -exec rm -rf {} +
			rm -f "$trash_dir"/info/*
			printf "\nTrash emptied.\n"
		fi
		tree -a "$trash_dir"
	else
		printf "\nNo trash to empty.\n"
	fi
}

[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

{
	printf "Date: %s \n" "$(date '+%F %R')"
	if [[ -d "$trash_dir" ]]; then
		empty_trash
	else
		printf "\nTrash directory does not exist.\n"
	fi
} > "$log_dir/$log_file" 2>&1
exit
