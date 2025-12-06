#!/usr/bin/env bash
##########################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : trash-cli 'sudo apt install trash-cli'
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Updated      : 09 Oct 2025
# Comments     : Run as a user cron job.
#              : Trash directory does not exist until a file is moved to the trash.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
##########################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

trash_count() {
	local count; count=$(/usr/bin/trash-list | wc -l)
	[[ "$count" -gt 0 ]] && return 0 || return 1
}

empty_trash() {
	local last_week; last_week=$(date -d "$(date) - 6 days" +%F)
	if trash_count; then
		printf "\nTrash contents:\n"
		/usr/bin/trash-list
		printf "\nRemoving trash older than %s...\n" "$last_week"
		/usr/bin/trash-empty 6
		if trash_count; then
			printf "\nTrash newer than %s...\n" "$last_week"
			/usr/bin/trash-list
		else
			printf "\nAll trash removed.\n"
		fi
	else
		printf "\nThe trash can is empty.\n"
	fi
}

main() {
  local script="${0##*/}"
  local version="4.7.25282"
  local lhost="${HOSTNAME:-$(hostname)}"
	local trash_dir=~/.local/share/Trash
	local log_dir=~/.local/share/logs
	local log_file="trash.log"
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

	{
		printf "%s Local Trash Log\n" "$lhost"
		printf "Date: %(%F %R)T\n"
		if ! dpkg -l trash-cli > /dev/null 2>&1; then
			printf "trash-cli package is not installed.\n"
		elif [[ -d "$trash_dir" ]]; then
			empty_trash
		else
			printf "\nTrash directory does not exist.\nWill be created when a file is moved to the trash.\n"
		fi
		over_line "$script $version"
	} > "$log_dir/$log_file" 2>&1
	exit
}

main "$@"
