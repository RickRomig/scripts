#!/usr/bin/env bash
##########################################################################
# Script Name  : ren-ext.sh
# Description  : Renames file extensions in the current directory
# Dependencies : rename
# Arguments    : File extenstion to be changed
# Author       : Copyright (C) 2017, Richard Romig
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 2017
# Updated      : 14 Mar 2026
# Comments     : File extensions are not case sensitive, but will change to lowercase.
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

## Variables ##

readonly script="${0##*/}"
readonly version="4.0.26073"

## Functions ##

help() {
	local errcode="${1:-1}"
	local updated="14 Mar 2026"
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
  local ext="${1,,}"
  # Rename file extensions based on the passed argument
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
  local file
  check_package rename
  [[ "$extension" ]] || read -rp "Enter an extension to rename: " extension
  [[ "$extension" == "-h" || "$extension" == "--help" ]] && help 0
  for file in ./*."$extension"; do
    if [[ -e "$file" ]]; then
      printf "Renaming .%s file extensions\n" "$extension"
      break
    else
      printf "No files with .%s extension found\n" "$extension"  >&2
      exit "$E_FILENOTFOUND"
    fi
  done
  rename_extension "$extension"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
