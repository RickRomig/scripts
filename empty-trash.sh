#!/usr/bin/env bash
###############################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : trash-cli 'sudo apt install trash-cli'
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Updated      : 04 Sep 2024 Version 3.1.24248
# Comments     : Run as a user cron job.
#              : Trash directory does not exist until a file is moved to the trash.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

readonly trash_dir="$HOME/.local/share/Trash"
readonly log_dir="$HOME/.local/share/logs"
readonly log_file="trash.log"
last_week=$(date -d "$(date) - 7 days" +%F)

empty_trash() {
	if [[ $(/usr/bin/trash-list | wc -l) -gt 0 ]]; then
		printf "\nTrash contents:\n---------------\n"
		/usr/bin/trash-list
		printf "Removing trash before %s...\n" "$last_week"
		/usr/bin/trash-empty 7
		if [[ $(/usr/bin/trash-list | wc -l) -gt 0 ]]; then
			printf "Trash after %s...\n" "$last_week"
			/usr/bin/trash-list
		else
			printf "All trash removed.\n"
		fi
	else
		printf "\nNo trash to empty.\n"
	fi
}

[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

{
	printf "Date: %s \n" "$(date '+%F %R')"
	if ! dpkg -l trash-cli > /dev/null 2>&1; then
		printf "trash-cli package is not installed.\n"
	elif [[ -d "$trash_dir" ]]; then
		empty_trash
	else
		printf "\nTrash directory does not exist.\nWill be created when a file is moved to the trash.\n"
	fi
} > "$log_dir/$log_file" 2>&1
exit
