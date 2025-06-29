#!/usr/bin/env bash
##########################################################################
# Script Name  : nosleep.sh
# Description  : Script to disable sleep and hiberation on Debian-based systems
# Dependencies : None
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 18 Jul 2023
# Last updated : 29 Jun 2025
# Comments     :
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

## Global Variables ##

script_dir=$(dirname "$(readlink -f "${0}")")

## Functions ##

set_nosleep() {
  local -r sleep_file="/etc/systemd/sleep.conf"
  local -r sed_file="$script_dir/files/nosleep.sed"
  if [[ -f "$sed_file" ]]; then
    sudo_login 2
    sudo sed -i.bak -f "$sed_file" "$sleep_file"
    printf "%s modified. Backup (%s.bak) created.\n" "$sleep_file" "${sleep_file##*/}"
    return 0
  else
    printf "A required file (%s) was not found.\n" "${sed_file##*/}"  >&2
    printf "Operation could not continue.\n" >&2
    return 1
  fi
}

main() {
  local script="${0##*/}"
  local -r version="1.4.25180"
  printf "Disables sleep and hiberation on Debian-based systems.\n"
  set_nosleep; code="$?"
  over_line "$script $version"
  exit "$code"
}

## Execution ##

main "$@"
