#!/usr/bin/env bash
##########################################################################
# Script Name  : ren-ext.sh
# Description  : Renames file extensions in the current directory
# Dependencies : rename
# Arguments    : File extenstion to be changed
# Author       : Copyright (C) 2017, Richard Romig
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 2017
# Updated      : 30 May 2026
# Comments     : File extensions are not case sensitive, but will change to lowercase.
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

## Load function library ##
# shellcheck source=/home/rick/bin/functionlib
source functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Global Variables ##

readonly script="${0##*/}"
readonly version="4.2.26150"

## Functions ##

help() {
	local errcode="${1:-1}"
	local updated="30 May 2026"
	cat << _HELP_
${orange}$script${normal} $version ($updated)
Bulk renames file extensions in the current diectory.

${green}Usage:${normal} $script <file-extension>
${orange}Example:${normal} $script JPG
* Input file extensions are not case sensitive.
* Any combination of upper and lower case is acceptable.
* File extensions will be converted to lowercase.
_HELP_
  exit "$errcode"
}

rename_extension() {
  local -l ext="$1"
  # Rename file extensions based on the passed argument
  printf "Renaming .%s file extensions\n" "$ext"
  case "$ext" in
    htm|html )
      rename -v 's/\.HTML?$/\.html/i' ./* ;;
    jpg|jpeg )
      rename -v 's/\.JPE?G$/\.jpg/i' ./* ;;
    mpg|mpeg )
      rename -v 's/\.MPE?G$/\.mpg/i' ./* ;;
    * )
      rename -v 's/(\.[A-Z]+$)/lc($1)/gei' -- *.*[A-Z]*
  esac
}

main() {
  local extension="$1"
  check_package rename
  [[ "$extension" == "-h" || "$extension" == "--help" ]] && help 0
  rename_extension "$extension"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
