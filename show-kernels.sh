#!/usr/bin/env bash
##########################################################################
# Script Name  : show-kernels.sh
# Description  : Displays currently installed Linux kernels and headers
# Dependencies : none
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 19 Feb 2026
# Updated      : 16 Aug 2026
# Version      : 1.4.26228
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

show_linux_headers() {
  local header_list
  printf "\n%sCurrently installed Linux headers:%s\n" "$green" "$normal"
  header_list=$(awk '/^ii/ && /-headers-/ {print $2}' < <(dpkg --list) | grep -v 'tools' | sort -r)
  [[ "$header_list" ]] || { printf "No Linux headers installed.\n"; return 0; }
  printf "%s\n" "$header_list"
  return 0
}

show_linux_images() {
  printf "%sActive kernel:%s %s\n\n" "$orange" "$normal" "$(uname -r)"
  printf "%sCurrently installed Linux images:%s\n" "$green" "$normal"
  awk '/^ii/ && /linux-image/ {print $2}' < <(dpkg --list) | sort -r
  return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="1.4.26228"
  show_linux_images
  show_linux_headers
  over_line "$script $version"
	exit
}

main "$@"
