#!/usr/bin/env bash
###############################################################################
# Script Name  : rm-duplicates.sh
# Description  : Find file sizes & use to potentially ID duplicate files
# Dependencies :
# Arguments    : None (-h or --help for usage)
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 19 Feb 2026
# Updated      : 03 Aug 2026
# Version      : 0.2.26215 (ALPHA)
# Comments     :
# TODO (Rick)  : Still needs work.
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful,# but WITHOUT
# ANY WARRANTY; without even the implied warranty of# MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

TMP_FILE=$(mktemp -q) || die "Failed to create temporary file." "$E_TEMP_FILE"

help() {
	local -r script="$1"
  local -r version="$2"
  local -ri errcode="${3:-1}"
	local -r updated="03 Aug 2026"
  cat << _HELP_
	${orange}$script${normal} $version, Updated: $updated
	Run this script from in the directory you want to find dupliate files.
	Have a second terminal window open in which to compare suspected duplicate.
	Remove duplicates as needed.
_HELP_
  exit "$errcode"
}

# shellcheck disable=SC2317 # Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
cleanup() {
  [[ -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"
}

main() {
  local -r script="${0##*/}"
  local -r version="0.2.26215"
  trap cleanup EXIT
  [[ "$1" == "-h" || "$1" == "--help" ]] && help "$script" "$version" 0
  # find file sizes
  awk '{print $5, $9}' < <(find . -type f -size +1M -exec ls -l {} \;) | sort -n > "$TMP_FILE"
  # filter duplicates
  awk 'NR==FNR{count[$1]++; next} count[$1]>1' "$TMP_FILE" "$TMP_FILE" | less -N
  over_line "$script $version"
	exit
}

main "$@"
