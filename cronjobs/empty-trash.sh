#!/usr/bin/env bash
##########################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : trash-cli 'sudo apt install trash-cli'
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Updated      : 05 May 2025
# Comments     : Run as a user cron job. '~/.local/bin/empty-trash.sh'
#              : Trash directory does not exist until a file has been moved to the trash.
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

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

trash_empty() {
	local count
	count=$(wc -l < <(/usr/bin/trash-list))
	[[ "$count" -eq 0 ]] && return "$TRUE" || return "$FALSE"
}

empty_trash() {
	local last_week
	last_week=$(date -d "$(date) - 6 days" +%F)
	if trash_empty; then
		printf "\nNo trash to be removed.\n"
		return
	fi
	printf "\nTrash contents:\n"
	/usr/bin/trash-list
	printf "\nRemoving trash older than %s...\n" "$last_week"
	/usr/bin/trash-empty -v -f 6
	if trash_empty; then
		printf "\nAll trash has been removed.\n"
		return
	fi
	printf "\nTrash newer than %s:\n" "$last_week"
	/usr/bin/trash-list
}

main() {
  local -r script="${0##*/}"
  local -r version="5.2.26125"
  local -r lhost="${HOSTNAME:-$(hostname)}"
	local -r trash_dir=~/.local/share/Trash
	local -r log_dir=~/.local/share/logs
	local -r log_file="trash.log"
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"

	{
		printf "%s Local Trash Log\n" "$lhost"
		printf "Date: %(%F %R)T\n"
		if [[ ! -d "$trash_dir" ]]; then
			printf "\nTrash directory does not exist.\nIt will be created when a file is moved to the trash.\n"
		elif grep -q '^ii' < <(dpkg -l trash-cli 2>/dev/null); then
			empty_trash
		else
			printf "trash-cli package is not installed.\n"
		fi
		over_line "$script $version"
	} > "$log_dir/$log_file" 2>&1
	exit
}

main "$@"
