#!/usr/bin/env bash
###############################################################################
# Script Name  : hb-late.sh
# Description  : Create HomeBank archive after the end of the month.
# Dependencies : zip
# Arguments    : none
# Author       : Copyright (C) 2019, Richard B. Romig, LudditeGeek @ Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Comments     : Use only if hb-archive.sh fails to run on 1st of the month.
# Created      : 02 Sep 2019
# Updated      : 09 Sep 2026
# Version      : 4.4.26252
# TODO (rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

trim_error_log() {
	local -r log_file="$1"
	local -i log_len
	log_len=$(wc -l < "$log_file")
	(( log_len > 12 )) && sed -i '1d' "$log_file"
	return 0
}

delete_old_archives() {
	local -r arc_dir="$1"
	find "$arc_dir" -daystart -mtime +1095 -exec rm {} +
	return 0
}

update_log_files() {
	local -ri status="$1"
	local -r arc_date="$2"
	local -r arc_dir="$3"
	local -r err_log="$4"
	local -r log_file=~/.local/share/logs/HomeBank-archive.log
	# Write to log in the archive directory
	printf "%sHomeBank backup files for %s archived.%s\n" "$orange" "$arc_date" "$normal"
	if (( status == 0 )); then
		printf "%(%F)T - HomeBank Archive successful.\n" > "$arc_dir/$err_log"
	else
		printf "%(%F)T - HomeBank Archive had errors.\n" > "$arc_dir/$err_log"
		printf "Zip Error Code: %d\n" "$status" >&2
	fi
	# Write to error log
	{
		printf "%(%a|%F|%R)T|%s|" -1 "$arc_date"
		(( status == 0 )) && printf "successful\n" || printf "had errors\n"
	} >> "$log_file"
	trim_error_log "$log_file"
	delete_old_archives "$arc_dir"
	return "$status"
}

monthly_archive() {
	local -r hb_dir=~/Documents/HomeBank
	local -r arc_dir=~/Downloads/archive/homebank
	local -r err_log=HomeBank-error.log
	local ref_date arc_date hb_archive
	arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +"%B %Y")   # 2 calendar months previous
	ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y)     # first day of the previous month
	hb_archive=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)-backup.zip
	zip -qmtt "$ref_date" "$arc_dir/$hb_archive" "$hb_dir/*.bak" 2> "$arc_dir/$err_log"
	local -i status="$?"
	update_log_files "$status" "$arc_date" "$arc_dir" "$err_log"
	return "$status"
}

main() {
	local -r script="${0##*/}"
	local -r version="4.4.26252"
	local -r lhost="${HOSTNAME:-$(hostname)}"
	local -r fhost="hp-800g2-sff"
	local -i exit_code=0
	[[ "$lhost" != "$fhost" ]] && die "$script must be run from the $fhost." "$E_INVALID_HOST"
	check_package zip
	printf "Archives .bak files if hb-archive.sh doesn't run on the 1st of the month.\n"
	monthly_archive
	exit_code="$?"
	over_line "$script $version"
	exit "$exit_code"
}

main "$@"
