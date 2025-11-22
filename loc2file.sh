#!/usr/bin/env bash
#####################################################################
# Script Name  : loc2file.sh
# Description  : Wrapper for fnloco/lloc. LOC data to stdout as it
#              : redirects it to a file.
# Dependencies : fnloc, lloc, tee
# Arguments    : C/C++ source code or header file
# Author       : Copyright (C) 2019, Richard B. Romig
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 29 Jan 2019
# Updated      : 21 Nov 2025
# Comments     : Processes one C/C++ source file and matching header.
# TODO (rick)  : Process multiple source & header files in a project.
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
#####################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#####################################################################

readonly script="${0##*/}"
readonly version="3.1.25325"

help() {
  local errcode="${1:-2}"
  local updated="21 Nov 2025"
  printf "%s %s, updated %s\n" "$script" "$version" "$updated"
  printf "Usage: %s sourcefile\n" "$script"
  printf "Acceptable file extensions are: .c .cpp .cc .h .hh\n"
  exit "$errcode"
}

process_source() {
  local cSource="$1"
  local locFile="$2"
  local baseFile="${cSource%%.*}"
  /usr/local/bin/fnloc "$cSource" | tee "$locFile"
  # Process matching header file if it exists
  [[ -f "$baseFile.h" ]] && process_header "$baseFile.h" "$locFile"
  [[ -f "$baseFile.hh" ]] && process_header "$baseFile.hh" "$locFile"
}

process_header() {
  local headerFile="$1"
  local locFile="$2"
  /usr/local/bin/lloc "$headerFile" | tee -a "$locFile"
}

print_header() {
  local -r copyright="Copyright 2018-2021"
  local -r author="Richard B. Romig"
  printf "%s\n" "$script $version"
  printf "%s\n" "$copyright, $author"
  printf "%s\n" "====================================="
}

begin_process() {
  local cSource="$1"
  local locFile="${cSource%%.*}.loc"
  local ext="${cSource##*.}"
  print_header
  printf "Writing LOC data to %s...\n" "$locFile"
  case "$ext" in
    c|cc|cpp )
      process_source "$cSource" "$locFile"
      printf "Logical lines of code data for %s written to %s." "$cSource" "$locFile"
      ;;
    h|hh )
      process_header "$cSource" "$locFile"
      printf "Logical lines of code data for %s written to %s." "$cSource" "$locFile"
      ;;
    * )
      printf "\e[91mError:\e[0m Invalid file extension." >&2; help 2
  esac
}

main() {
  local cSource
  if [[ "$#" -eq 0 ]]; then
    printf "\e[91mError:\e[0m No argument provided.\n" >&2
    help 1
  elif [[ ! -f "$1" ]]; then
    printf "\e[91mError:\e[0m %s not found.\n" "$1" >&2
    help 2
  else
    cSource="$1"
    begin_process "$cSource"
  fi
  exit
}

main "$@"
