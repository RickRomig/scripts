#!/usr/bin/env bash
##########################################################################
# Script Name  : gretire.sh
# Description  : remove a file from a git repo and archive it.
# Dependencies : git zip
# Arguments    : file to be removed
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 02 Jul 2026
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

## Load function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

help() {
  local -r script="$1"
  local -r version="$2"
	local -r errcode="${3:-1}"
	local updated="02 Jul 2026"
	cat << _HELP_
${orange}$script${normal} $version ($updated)
Retires a script in a Git repo by moving it to a zipped archive.

${green}Usage:${normal} $script [script-name] [OPTION]
${orange}Available options:${normal}
  -h | --help  Show this help message and exit
${bold}NOTES:${normal}
Do not use to retire a script that is not in a git repository. Use 'retire-script.sh' instead.
If no argument is passed, the user will be prompted for the name of the script to be retired.
_HELP_
	exit "$errcode"
}

check_dependencies() {
  local packages=( git zip )
  check_packages "${packages[@]}"
  return 0
}

is_git_repo() {
  [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]  && return "$TRUE" || return "$FALSE"
}

retire_script() {
  local filename="$1"
  archive=~/Downloads/archives/retired-scripts.zip
  printf "Archiving %s..." "$filename"
  zip -u "$archive" "$filename"
  git rm "$filename"
  git commit -m "$filename retired and archived." --no-verify
  git push
  return 0
}

check_args() {
  local filename="$1"
  [[ "$filename" ]] || read -rp "Enter the name of the script to be retired: " filename
  if [[ ! -f "$filename" ]]; then
    printf "%s not found in this git repository.\n" "$filename" >&2
    return "$E_FILENOTFOUND"
  fi
  retire_script "$filename"
  return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="4.5.26183"
  local exit_code=0
	[[ "$1" == "-h" || "$1" == "--help" ]] && help "$script" "$version" 0
  local filename="$1"
  if is_git_repo; then
    check_dependencies
    check_args "$filename"
    exit_code="$?"
  else
    printf "%s This is not a git repositiory.\n" "$RED_WARNING" >&2
    printf "Run 'retire-script.sh' to retire scripts that are not in a git repository.\n" >&2
    exit_code="$E_INVALID_ARG"
  fi
  over_line "$script $version"
  exit "$exit_code"
}

## Execution ##

main "$@"
