#!/usr/bin/env bash
###############################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : gio (libglib2.0-bin)
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Last updated : 28 Aug 2024 Version 2.1.24241
# Comments     : Run as a user cron job.
#              : Trash directory does not exist until a file is moved to the trash.
#              : Tested with Debian 11/12, LMDE 6, Mint 21.x, Mint 22, MX Linux 23.1, BunsenLabs 11.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

readonly trash_dir="$HOME/.local/share/Trash"
readonly log_dir="$HOME/.local/share/logs"
readonly log_file="trash.log"

check_gio() {
	dpkg -l libglib2.0-bin >/dev/null 2>&1 && return 0 || return 1
}

empty_trash() {
	if [[ $(find "$trash_dir/files" -type f | wc -l) -gt 0 ]]; then
		printf "\nTrash contents:\n---------------\n"
		gio trash --list 2>/dev/null || gio list -h "$trash_dir"/files
		gio trash --empty && printf "\nTrash emptied.\n" || printf "Trash left behind.\n"
	else
		printf "\nNo trash to empty.\n"
	fi
}

[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

{
	printf "Date: %s \n" "$(date '+%F %R')"
	if check_gio; then
		if [[ -d "$trash_dir" ]]; then
			empty_trash
		else
	    printf "\nTrash directory does not exist.\n"
		fi
	else
		printf "\n\e[91mERROR:\e[0m libglib2.0-bin not installed!\n"
	fi
} > "$log_dir/$log_file" 2>&1
exit
