#!/bin/bash
#####################################################################################
# Script Name  : package-filter.sh
# Description  : Filters available packages with FZF
# Dependencies : fzf
# Arguments    : none
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 15 Oct 2025
# Last updated : 01 Jul 2026
# Comments     : Original script Copyright (C) 2025  Kris Occhipinti
#              : Modified and adapted by Rick Romig
# TODO (Rick)  :
# License      : GNU General Public License, version 2
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
#####################################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.
#####################################################################################

### Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

search_packages() {
	# Based on code by Kris Occhipinti (with minor changes)
	local package #do_it
	package="$(
		apt-cache pkgnames |
			fzf -m --prompt="Enter Package Names: " \
				--preview "apt show {} 2>/dev/null" \
				--preview-window 'top:75%' |
				tr "\n" " "
	)"
	package="${package// /}"	# remove trailing whitespace
	[[ "$package" ]] || { printf "Nothing selected\n"; return; }
	installed "$package" && { printf "%s is already installed.\n" "$package"; return 0; }
	if default_no	"Install ${package}?"; then
		sudo_login 2
		printf "\n"
		sudo apt install "$package"
	else
		printf "%s selected but not installed.\n" "$package"
	fi
	return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="1.5.26182"
  check_package fzf
  search_packages
  over_line "$script $version"
  exit
}

main "$@"
