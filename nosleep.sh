#!/usr/bin/env bash
##########################################################################
# Script Name  : nosleep.sh
# Description  : Script to disable sleep and hiberation on Debian-based systems
# Dependencies : None
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 18 Jul 2023
# Last updated : 03 Jan 2026
# Comments     : Script started, output log is 'typescript'. (Then runs .bashrc)
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

main() {
  local script sed_file sleep_file version
  script=$(basename "$0")
  version="1.3.25003"
  sleep_file="/etc/systemd/sleep.conf"
  sed_file="$HOME/bin/files/nosleep.sed"

  printf "Disables sleep and hiberation on Debian-based systems.\n"
  [[ -f "$sed_file" ]] || die "A required files ($(basename "$sed_file")) was not found." 1
  sudo_login 2
  sudo sed -i.bak -f "$sed_file" "$sleep_file"
  printf "%s modified. Backup (%s.bak) created.\n" "$sleep_file" "$sleep_file"
  over_line "$script $version"
}

## Execution ##

main "$@"
