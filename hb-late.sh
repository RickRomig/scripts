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
# Updatd       : 18 May 2026
# TODO (rick)  :
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
###############################################################################

## Load function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

trim_log() {
	local -i log_len
	local -r log_dir="$1"
	local -r log_file="$2"
	log_len=$(wc -l < "$log_dir/$log_file")
  (( log_len > 12 )) && sed -i '1d' "$log_dir/$log_file"
}

del_old_archives() {
	local arc_dir="$1"
	find "$arc_dir" -daystart -mtime +1095 -exec rm {} +
}

update_log_files() {
  local status="$1"
  local arc_date="$2"
  local err_log="$3"
  local arc_dir=~/Downloads/archive/homebank
  local log_dir=~/.local/share/logs
  local log_file="HomeBank-archive.log"
  # Write to log in the archive directory
  echo "${orange}HomeBank backup files for $arc_date archived.${normal}"
  if (( status = 0 )); then
    echo "$(date +%F) - HomeBank Archive successful." > "$arc_dir/$err_log"
  else
    echo "$(date +%F) - HomeBank Archive had errors." >> "$arc_dir/$err_log"
    echo "Zip Error Code: $status" >&2
  fi
  # Write to error log
  {
    printf "%(%a|%F|%R)T|%s|" -1 "$arc_date"
    (( status = 0 )) && printf "successful\n" || printf "had errors\n"
  } >> "$log_dir/$log_file"
	trim_log "$log_dir" "$log_file"
	del_old_archives "$arc_dir"
}

monthly_archive() {
  local ref_date arc_date hb_archive status
  local -r arc_dir=~/Downloads/archive/homebank
  local -r err_log="HomeBank-error.log"
  local -r hb_dir=~/Documents/HomeBank
  hb_archive=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)-backup.zip
  arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +"%B %Y")  # 2 calendar months previous
  ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y) # first day of the previous month

  zip -qmtt "$ref_date" "$arc_dir/$hb_archive" "$hb_dir/*.bak" 2> "$arc_dir/$err_log"
  status="$?"
  update_log_files "$status" "$arc_date" "$err_log"
}

main() {
  local -r script="${0##*/}"
  local -r version="4.1.26138"
  local -r lhost="${HOSTNAME:-$(hostname)}"
  local -f fhost="hp-800g2-sff"

  [[ "$lhost" != "$fhost" ]] && die "$script must be run from the $fhost." "$E_INVALID_HOST"
  check_package zip
  printf "Archives .bak files if hb-archive.sh doesn't run on the 1st of the month.\n"
  monthly_archive
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
