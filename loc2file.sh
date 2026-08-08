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
# Updated      : 07 Aug 2026
# Version      : 3.4.26219
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

readonly E_FILENOTFOUND=3
readonly E_MISSING_ARG=6
readonly E_INVALID_ARG=7

help() {
  local -r script="$1"
  local -r version="$2"
  local -i errcode="${3:-1}"
  local -r updated="07 Aug 2026"
  printf "%s %s, updated %s\n" "$script" "$version" "$updated"
  printf "Usage: %s sourcefile\n" "$script"
  printf "Acceptable file extensions are: .c .cpp .cc .h .hh\n"
  exit "$errcode"
}

process_source() {
  local -r cSource="$1"
  local -r locFile="$2"
  local -r baseFile="${cSource%%.*}"
  tee "$locFile" < <(/usr/local/bin/fnloc "$cSource")
  # Process matching header file if it exists
  [[ -f "$baseFile.h" ]] && process_header "$baseFile.h" "$locFile"
  [[ -f "$baseFile.hh" ]] && process_header "$baseFile.hh" "$locFile"
  return 0
}

process_header() {
  local -r headerFile="$1"
  local -r locFile="$2"
  tee -a "$locFile" < <(/usr/local/bin/lloc "$headerFile")
  return 0
}

print_title() {
  local -r script="$1"
  local -r version="$2"
  local -r copyright="Copyright 2018-2026"
  local -r author="Richard B. Romig"
  printf "%s\n" "$script $version"
  printf "%s, %s\n" "$copyright" "$author"
  printf "%s\n" "====================================="
  return 0
}

begin_process() {
  local -r cSource="$1"
  local -r locFile="${cSource%%.*}.loc"
  local -r ext="${cSource##*.}"
  print_title "$script" "$version"
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
      printf "\e[91mError:\e[0m Invalid file extension." >&2
      return "$E_INVALID_ARG"
  esac
}

main() {
  local -r script="${0##*/}"
  local -r version="3.4.26219"
  local -r cSource="$1"
  if [[ $# -eq 0 ]]; then
    printf "\e[91mError:\e[0m No argument provided.\n" >&2
    help "$script" "$version" "$E_MISSING_ARG"
  elif [[ ! -f "$cSource" ]]; then
    printf "\e[91mError:\e[0m %s not found.\n" "$1" >&2
    help "$script" "$version" "$E_FILENOTFOUND"
  fi
  begin_process "$cSource" || help "$script" "$version" "$E_INVALID_ARG"
  exit
}

main "$@"
