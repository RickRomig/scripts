#!/usr/bin/env bash
###############################################################################
# Script Name  : empty-trash.sh
# Description  : Empty the local trash directory
# Dependencies : trash-cli 'sudo apt install trash-cli'
# Arguments    : none
# Author       : Copyright © 2023, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 21 Nov 2023
# Updated      : 04 Jul 2025
# Comments     : Run as a user cron job.
#              : Trash directory does not exist until a file is moved to the trash.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

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

# shellcheck disable=SC2001
over_line() {
  local char len line title
  title="$1"
  char="${2:--}"
  len=${#char}
  (( len > 1 )) && char=${char::1}
  line=$(echo "$title" | sed "s/./$char/g")
  printf "%s\n%s\n"  "$line" "$title"
}

main() {
  local script="${0##*/}"
  local version="4.6.25189"
  local lhost="${HOSTNAME:-$(hostname)}"
	local trash_dir="$HOME/.local/share/Trash"
	local log_dir="$HOME/.local/share/logs"
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
