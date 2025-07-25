#!/usr/bin/env bash
#####################################################################
# Script Name  : dos2linux.sh
# Description  : converts DOS text files to Linux format
# Dependencies : none
# Arguments    : file to be converted
# Author       : Copyright (C) 2019, Richard Romig, 24 Jan 2019
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 24 Jan 2019
# Updated      : 24 Jul 2025
# TODO (Rick)  :
# Comment      : removes DOS carriage return ('\r') characters
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

## Global Variables ##

readonly script="${0##*/}"
readonly version="1.2.25205"

## Functions ##

help() {
	local errcode="${1:-2}"
	local updated="24 Jul 2025"
  cat << _HELP_
${orange}$script${normal} $version, Updated: $updated
Convert DOS text files to Linux format by removing carriage returns.

${green}Usage:${normal} $script [OPTION]
${orange}Available options:${normal}
  -h | --help  Show help
NOTE: Converts files in the current working directory.
_HELP_
  exit "$errcode"
}

convert_file() {
  local filename="$1"
  printf "Removing the carriage return characters from %s\n" "$filename"
  printf "and creating a backup (%s.bak) of the orginal file."  "$filename"
  sed -i.bak 's/\r//g' "$filename"
}

main() {
  local filename

  if [[ "$#" -eq 0 ]]; then
    printf "%s No argument passed.\n" "$RED_ERROR" >&2
    help 1
  elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help 0
  elif [[ ! -f "$1" ]]; then
    printf "%s %s not found.\n" "$RED_ERROR" "$1" >&2
    help 2
  else
    filename="$1"
    convert_file "$filename"
  fi
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
