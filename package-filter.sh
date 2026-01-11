#!/bin/bash
###############################################################################
# Script Name  : package-filter.sh
# Description  : Filters available packages with FZF
# Dependencies : fzf
# Arguments    : none
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 15 Oct 2025
# Last updated : 11 Jan 2026
# Comments     : Original script Copyright (C) 2025  Kris Occhipinti
#              : Modified and adapted by Rick Romig
# TODO (Rick)  :
# License      : GNU General Public License, version 2
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
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
###############################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x ~/bin/functionlib ]]; then
  source ~/bin/functionlib
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

search_packages() {
	# Based on code by Kris Occhipinti (with minor changes)
	local package do_it
	package="$(
		apt-cache pkgnames |
			fzf -m --prompt="Enter Package Names: " \
				--preview "apt show {} 2>/dev/null" \
				--preview-window 'top:75%' |
				tr "\n" " "
	)"
	package="${package// /}"	# remove trailing whitespace
	[[ "$package" ]] && read -n1 -rp "Install ${package}? [y/N]: " do_it
	printf '\n'
	if [[ "${do_it,,}" != "y" ]]; then
		printf "%s installation declined.\n" "$package"
		return
	fi
	sudo_login 2
	sudo apt install "$package"
	printf "\nDone\n"
}

main() {
  local -r script="${0##*/}"
  local -r version="1.2.26011"
  check_package fzf
  search_packages
  over_line "$script $version"
  exit
}

main "$@"
