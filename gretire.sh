#!/usr/bin/env bash
##########################################################################
# Script Name  : gretire.sh
# Description  : remove a file from a git repo and archive it.
# Dependencies : git zip
# Arguments    : file to be removed
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 22 Jul 2025
# Comments     : Must be run from the main directory of a git repo.
#              : For files in subdirectories, include the path from the repo directory.
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
  exit 1
fi

set -eu

## Functions ##

check_dependencies() {
  local packages=( git zip )
  check_packages "${packages[@]}"
}

retire_script() {
  local retired
  local filename="$1"
  local archive="retired-scripts.zip"
  local archive_d="$HOME//Downloads/archives"
  retired="${filename}.$(date +'%y%j')"
  git mv "$filename" "$retired"
  git commit -m "$filename renamed to $retired for retirement and archiving." --no-verify
  zip -u "$archive_d/$archive" "$retired"
  git rm "$retired"
  git commit -m "$retired was retired and archived." --no-verify
  git push
}

main() {
  local script="${0##*/}"
	local version="2.4.25203"
  [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || die "You are not in a git repositiory." 1
  if [[ "$#" -eq "0" ]]; then
    read -rp "Enter the name of the script to be retired: " filename
  else
    filename="$1"
  fi
  [[ -f "$filename" ]] || die "$filename not found." 1
  check_dependencies
  retire_script "$filename"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
