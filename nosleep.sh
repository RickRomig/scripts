#!/usr/bin/env bash
###############################################################################
# Script Name  : nosleep.sh
# Description  : Script to disable sleep and hiberation on Debian-based systems
# Dependencies : None
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 18 Jul 2023
# Updated      : 01 Aug 2026
# Version      : 2.4.26213
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify  it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

set_nosleep() {
  local script_dir
  script_dir=$(dirname "$(readlink -f "${0}")")
  local -r sed_file="$script_dir/files/nosleep.sed"
  if [[ ! -f "$sed_file" ]]; then
    printf "A required file (%s) was not found.\n" "${sed_file##*/}" >&2
    printf "Operation could not continue.\n" >&2
    return "$E_FILENOTFOUND"
  fi
  sudo_login 2
  [[ -d /etc/systemd/sleep.conf.d ]] || sudo mkdir -p /etc/systemd/sleep.conf.d
  sudo cp -v /etc/systemd/sleep.conf /etc/systemd/sleep.conf.d/99-sleep.conf
  sudo sed -i -f "$sed_file" /etc/systemd/sleep.conf.d/99-sleep.conf
  printf "99-sleep.conf created.\n"
  return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="2.4.26213"
	local -i exit_code=0
  printf "Disables sleep and hiberation on Debian-based systems.\n"
  set_nosleep
  exit_code="$?"
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
