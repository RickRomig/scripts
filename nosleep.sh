#!/usr/bin/env bash
##########################################################################
# Script Name  : nosleep.sh
# Description  : Script to disable sleep and hiberation on Debian-based systems
# Dependencies : None
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 18 Jul 2023
# Last updated : 25 Jul 2025
# Comments     :
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

## Functions ##

set_nosleep() {
  local script_dir
  script_dir=$(dirname "$(readlink -f "${0}")")
  local -r sleep_dir="/etc/systemd/sleep.conf.d"
  local -r sysd_dir="/etc/systemd"
  local -r sleep_file="sleep.conf"
  local -r sed_file="$script_dir/files/nosleep.sed"
  if [[ ! -f "$sed_file" ]]; then
    printf "A required file (%s) was not found.\n" "${sed_file##*/}" >&2
    printf "Operation could not continue.\n" >&2
    return 1
  fi
  sudo_login 2
  [[ -d "$sleep_dir" ]] || sudo mkdir -p "$sleep_dir"
  sudo cp -v "$sysd_dir/$sleep_file" "$sleep_dir/"
  sudo sed -i.bak -f "$sed_file" "$sleep_dir/$sleep_file"
  printf "%s modified. Backup (%s.bak) created.\n" "$sleep_file" "${sleep_file##*/}"
  return 0
}

main() {
  local script="${0##*/}"
  local -r version="2.0.25329"
  printf "Disables sleep and hiberation on Debian-based systems.\n"
  set_nosleep; code="$?"
  over_line "$script $version"
  exit "$code"
}

## Execution ##

main "$@"
