#!/usr/bin/env bash
##########################################################################
# Script Name  : show-kernels.sh
# Description  : Displays currently installed Linux kernels and headers
# Dependencies : none
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 19 Feb 2026
# Last updated : 29 May 2026
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

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

show_linux_headers() {
  local header_list
  printf "\nCurrently installed linux headers:\n"
  header_list=$(awk '/-headers-/ {print $2}' < <(dpkg --list) | grep -v 'tools' | sort -r)
  [[ "$header_list" ]] || { printf "No Linux headers installed\n"; return; }
  printf "%s\n" "$header_list"
}

show_linux_images() {
  printf "Active kernel: %s\n\n" "$(uname -r)"
  printf "Currently installed Linux images:\n"
  awk '/linux-image/ {print $2}' < <(dpkg --list) | sort -r
}

main() {
  local -r script="${0##*/}"
  local -r version="1.2.26149"
  show_linux_images
  show_linux_headers
  over_line "$script $version"
	exit
}

## Execution ##

main "$@"
