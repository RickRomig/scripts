#!/usr/bin/env bash
##########################################################################
# Script Name  : gretire.sh
# Description  : remove a file from a git repo and archive it.
# Dependencies : git zip
# Arguments    : file to be removed
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 11 Oct 2025
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

## Global Variables ##

readonly script="${0##*/}"
readonly version="3.0.25284"

## Functions ##

help() {
	local errcode="${1:-2}"
	local updated=" 11 Oct 2025"
	cat << _HELP_
${orange}$script${normal} $version ($updated)
Retires a script in a Git repo by moving it to a zipped archive.

${green}Usage:${normal} $script <script-name>
${orange}Available options:${normal}
  -h | --help  Show this help message and exit
${bold}NOTE:${normal}
Do not use to retire a script not in a git repository. Use 'retire-script.sh' instead.
_HELP_
	exit "$errcode"
}

check_dependencies() {
  local packages=( git zip )
  check_packages "${packages[@]}"
}

git_repo() {
  [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]  && return "$TRUE" || return "$FALSE"
}

retire_script() {
  local filename="$1"
  local retired_name
  local archive="retired-scripts.zip"
  local archive_d="$HOME//Downloads/archives"
  retired_name="${filename}.$(date +'%y%j')"
  git mv "$filename" "$retired_name"
  git commit -m "$filename renamed to $retired_name for retirement and archiving." --no-verify
  zip -u "$archive_d/$archive" "$retired_name"
  git rm "$retired_name"
  git commit -m "$retired_name retired and archived." --no-verify
  git push
}

main() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && help 0
  local filename
  if git_repo; then
    if [[ "$#" -eq "0" ]]; then
      read -rp "Enter the name of the script to be retired: " filename
    else
      filename="$1"
    fi
    [[ -f "$filename" ]] || { printf "%s %s not found.\n" "$RED_ERROR" "$filename" >&2; help 2; }
    check_dependencies
    retire_script "$filename"
  else
    printf "%s This is not a git repositiory.\n" "$RED_WARNING" >&2
    printf "Run 'retire-script.sh' to retire scripts outside of a git repository\n" >&2
  fi
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
