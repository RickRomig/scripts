#!/usr/bin/env bash
###############################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Last updated : 21 Nov 2023 Version 0.1.0
# Comments     : Run as a user cron job daily, weekly, or monthly
#              : Trash directory does not exist until a file is sent to trash by file manager.
#              : Tested with Debian 11/12, LMDE 6, Mint 21.2, MX Linux 23.1, BunsenLabs 11.
# TODO (Rick)  : 
# License      : GNU General Public License, version 2.0
###############################################################################

readonly trash_dir="$HOME/.local/share/Trash"
readonly log_dir="$HOME/.local/share/logs"
readonly log_file="trash.log"

[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

{
	printf "%s \n" "$(date '+%F %R')"
	if [[ -d "$trash_dir" ]]; then
    	if [[ $(ls -A "$trash_dir/files") ]]; then
        	rm -rf "$trash_dir"/files/*
        	rm -rf "$trash_dir"/info/*
        	printf "Trash emptied.\n"
    	else
        	printf "No trash to empty.\n"
    	fi
	else
    printf "Trash directory does not exist.\n"
	fi
} > "$log_dir/$log_file" 2>&1
exit
