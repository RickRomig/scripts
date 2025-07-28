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
# Updated      : 28 Jul 2025
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
readonly version="3.0.25209"

usage() {
  local errcode="${1:-2}"
  local updated="28 Jul 2025"
  printf "%s %s, updated %s\n" "$script" "$version" "$updated"
  printf "Usage: %s sourcefile\n" "$script"
  printf "Acceptable file extensions are: .c .cpp .cc .h .hh\n"
  exit "$errcode"
}

process_source() {
  local CSOURCE="$1"
  local LOCFILE="$2"
  local BASEFILE="${CSOURCE%%.*}"
  /usr/local/bin/fnloc "$CSOURCE" | tee "$LOCFILE"
  # Process matching header file if it exists
  [[ -f "$BASEFILE.h" ]] && process_header "$BASEFILE.h" "$LOCFILE"
  [[ -f "$BASEFILE.hh" ]] && process_header "$BASEFILE.hh" "$LOCFILE"
}

process_header() {
  local HEADERFILE="$1"
  local LOCFILE="$2"
  /usr/local/bin/lloc "$HEADERFILE" | tee -a "$LOCFILE"
}

print_header() {
  local -r COPYRIGHT="Copyright 2018-2021"
  local -r AUTHOR="Richard B. Romig"
  printf "%s\n" "$script $version"
  printf "%s\n" "$COPYRIGHT, $AUTHOR"
  printf "%s\n" "====================================="
}

begin_process() {
  local CSOURCE="$1"
  local LOCFILE="${CSOURCE%%.*}.loc"
  local EXT="${CSOURCE##*.}"
  print_header
  printf "Writing LOC data to %s...\n" "$LOCFILE"
  case "$EXT" in
    c|cc|cpp )
      process_source "$CSOURCE" "$LOCFILE"
      printf "Logical lines of code data for %s written to %s." "$CSOURCE" "$LOCFILE"
      ;;
    h|hh )
      process_header "$CSOURCE" "$LOCFILE"
      printf "Logical lines of code data for %s written to %s." "$CSOURCE" "$LOCFILE"
      ;;
    * )
      printf "\e[91mError:\e[0m Invalid file extension." >&2; usage 2
  esac
}

main() {
  local CSOURCE
  if [[ "$#" -eq 0 ]]; then
    printf "\e[91mError:\e[0m No argument provided.\n" >&2
    usage 1
  elif [[ ! -f "$1" ]]; then
    printf "\e[91mError:\e[0m %s not found.\n" "$1" >&2
    usage 2
  else
    CSOURCE="$1"
    begin_process "$CSOURCE"
  fi
  exit
}

main "$@"
