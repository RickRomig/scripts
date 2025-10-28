#!/usr/bin/env bash
##########################################################################
# Script Name  : gretire.sh
# Description  : remove a file from a git repo and archive it.
# Dependencies : git zip
# Arguments    : file to be removed
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 28 Oct 2025
# Comments     : Must be run from the main directory of a git repo.
#              : For files in subdirectories, include the path from the repo directory.
#              : If file has been changed, commit the change before retiring.
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
readonly version="4.0.25301"

## Functions ##

help() {
	local errcode="${1:-2}"
	local updated=" 28 Oct 2025"
	cat << _HELP_
${orange}$script${normal} $version ($updated)
Retires a script in a Git repo by moving it to a zipped archive.

${green}Usage:${normal} $script <script-name>
${orange}Available options:${normal}
  -h | --help  Show this help message and exit
${bold}NOTES:${normal}
Do not use to retire a script not in a git repository. Use 'retire-script.sh' instead.
If no argument is passed, user will be prompted for the name of the script to be retired.
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
  if [[ ! -f "$filename" ]]; then
    printf "%s %s not found.\n" "$RED_WARNING" "$filename" >&2
    return
  fi
  zip -u ~/Downloads/archives/retired-scripts.zip "$filename"
  git rm "$filename"
  git commit -m "$filename retired and archived." --no-verify
  git push
}

check_args() {
  local filename="$1"
  if ! git_repo; then
    printf "%s This is not a git repositiory.\n" "$RED_WARNING" >&2
    printf "Run 'retire-script.sh' to retire scripts outside of a git repository.\n" >&2
    return
  fi
  [[ "$filename" ]] || read -rp "Enter the name of the script to be retired: " filename
  check_dependencies
  retire_script "$filename"
}

main() {
	[[ "$1" == "-h" || "$1" == "--help" ]] && help 0
  local filename="$1"
  check_args "$filename"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
