#!/usr/bin/env bash
###############################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : trash-cli 'sudo apt install trash-cli'
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Last updated : 03 Sep 2024 Version 3.0.24247
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
	if [[ $(/usr/bin/trash-list | wc -l) -gt 0 ]]; then
		printf "\nTrash contents:\n---------------\n"
		/usr/bin/trash-list
		/usr/bin/trash-empty 7
		/usr/bin/trash-list
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
