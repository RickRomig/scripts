#!/usr/bin/env bash
##########################################################################
# Script Name  : rm-duplicates.sh
# Description  : Find file sizes & use to potentially ID duplicate files
# Dependencies :
# Arguments    : None (-h or --help for usage)
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 19 Feb 2026
# Last updated : 19 Feb 2026
# Version      : 1.0.26050
# Comments     :
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
  exit 81
fi

## Global Variables ##

tmp_file=$(mktemp -q) || die "Failed to create temporary file." "$E_TEMP_FILE"

## Functions ##

help() {
	local -r script="$1"
	local -r updated="19 Feb 2026"
  cat << _HELP_
	${orange}$script${normal} $version, Updated: $updated
	Run this script from in the directory you want to find dupliate files.
	Have a second terminal window open in which to compare suspected duplicate.
	Remove duplicates as needed.
_HELP_
  exit
}

# shellcheck disable=SC2317 # Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
cleanup() {
  [[ -f "$tmp_file" ]] && rm -f "$tmp_file"
}

find_sizes() {
	find . -type f -size +1M -exec ls -l {} \; | awk '{print $5, $9}' | sort -n > "$tmp_file"
}

filter_duplicates() {
	awk 'NR==FNR{count[$1]++; next} count[$1]>1' "$tmp_file" "$tmp_file" | less -N
}

main() {
  local -r script="${0##*/}"
  local -r version="1.0.26050"
  trap cleanup EXIT
  [[ "$1" == "-h" || "$1" == "--help" ]] && help "$script"
  find_sizes
  filter_duplicates
  over_line "$script $version"
	exit
}

## Execution ##

main "$@"
