#!/usr/bin/env bash
##########################################################################
# Script Name  : gretire
# Description  : remove a file from a git repo and archive it.
# Dependencies : git zip
# Arguments    : file to be removed
# Author       : Copyright © 2024 Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 04 Jul 2024
# Last updated : 02 Jul 2025
# Comments     : Must be run from the main directory of a git repo.
#              : For files in subdirectories, include the path from the repo directory.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
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
  local filename retired archive archive_d
  filename="$1"
  retired="${filename}.$(date +'%y%j')"
  archive="retired-scripts.zip"
  archive_d="$HOME//Downloads/archives"
  git mv "$filename" "$retired"
  git commit -m "$filename renamed to $retired to be retired and archived." --no-verify
  zip -u "$archive_d/$archive" "$retired"
  git rm "$retired"
  git commit -m "$retired was retired and archived." --no-verify
  git push
}

main() {
  local filename script version
  script="${0##*/}"
	version="2.3.25183"
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
