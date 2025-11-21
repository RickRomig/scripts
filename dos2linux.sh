#!/usr/bin/env bash
#####################################################################
# Script Name  : dos2linux.sh
# Description  : converts DOS text file to Linux format
# Dependencies : none
# Arguments    : file to be converted
# Author       : Copyright (C) 2019, Richard Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 24 Jan 2019
# Updated      : 21 Nov 2025
# TODO (Rick)  :
# Comment      : removes DOS carriage return ('\r') characters
#              : Similar in function to dos2unix.
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
#####################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Functions ##

convert_file() {
  local filename="$1"
  printf "Removing the carriage return characters from %s\n" "$filename"
  printf "and creating a backup (%s.bak) of the orginal file."  "$filename"
  sed -i.bak 's/\r//g' "$filename"
}

main() {
  local script="${0##*/}"
  local version="2.0.25325"
  local filename="$1"
  printf "Converts DOS text file to Linux format by removing carriage returns.\n"
  [[ "$#" -eq 0 ]] && read -rp "Enter a DOS text file to process: " filename
  if [[ -f "$filename" ]]; then
    convert_file "$filename"
  else
    printf "%s %s not found.\n" "$RED_ERROR" "$filename" >&2
  fi
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
