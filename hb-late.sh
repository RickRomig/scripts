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
# Updatd       : 16 Jul 2025
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

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  echo -e "\e[91mERROR:\e[0m functionlib not found!" >&2
  exit 1
fi

set -eu

## Functions ##

trim_log() {
	local log_len log_dir log_file
	log_dir="$1"
	log_file="$2"
	log_len=$(wc -l < "$log_dir/$log_file")
	[[ "$log_len" -gt 12 ]] && sed -i '1d' "$log_dir/$log_file"
}

del_old() {
	local arc_dir="$1"
	find "$arc_dir" -daystart -mtime +1095 -exec rm {} +
}

update_log_file() {
  local status="$1"
  local arc_date="$2"
  local arc_dir="$HOME/Downloads/archive/homebank"
  local log_dir="$HOME/.local/share/logs"
  local log_file="HomeBank-archive.log"
  local err_log="HomeBank-error.log"
  {
    printf "%(%a|%F|%R)T|%s|" -1 "$arc_date"
    if (( status > 0 )); then
      printf "successful\n"
      echo "$(date +%F) - HomeBank Archive successful." > "$arc_dir/$err_log"
    else
      printf "had errors\n"
      echo "$(date +%F) - HomeBank Archive had errors. ($status)" >> "$arc_dir/$err_log"
    fi
  } >> "$log_dir/$log_file"
	trim_log "$log_dir" "$log_file"
	del_old "$arc_dir"
 }

monthly_archive() {
  local ref_date arc_date arc_dir hb_archive hb_dir status
  arc_dir=$HOME"/Downloads/archive/homebank"
  err_log="HomeBank-error.log"
  hb_dir=$HOME"/Documents/HomeBank"
  hb_archive=$(date -d "$(date +%Y-%m-01) - 2 months" +%Y-%m)-backup.zip
  arc_date=$(date -d "$(date +%Y-%m-01) - 2 months" +"%B %Y")  # 2 calendar months previous
  ref_date=$(date -d "$(date +%Y-%m-01) - 1 month" +%m%d%Y) # first day of the previous month

  zip -qmtt "$ref_date" "$arc_dir/$hb_archive" "$hb_dir/*.bak" 2> "$arc_dir/$err_log"
  status="$?"
  if [[ "$status" -eq 0 ]]; then
    echo "${orange}HomeBank backup files for $arc_date archived.${normal}"
    echo "$(date +%F) - HomeBank Archive successful." > "$arc_dir/$err_log"
  else
    echo "$(date +%F) - HomeBank Archive had errors." >> "$arc_dir/$err_log"
    echo "Zip Error Code: $status" >&2
  fi
  update_log_file "$status" "$arc_date"
}

main() {
  local script="${0##*/}"
  local version="3.2.25197"
  local lhost="${HOSTNAME:-$(hostname)}"
  local fhost="hp-800g2-sff"

  [[ "$lhost" != "$fhost" ]] && die "$script must be run from the $fhost."
  check_package zip
  printf "Archives .bak files if hb-archive.sh doesn't run on the 1st of the month.\n"
  monthly_archive
  over_line "$script $version "
  exit
}

## Execution ##

main "$@"
