#!/bin/bash
###############################################################################
# Script Name  : package-filter.sh
# Description  : Filters available packages with FZF
# Dependencies : fzf
# Arguments    : none
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 15 Oct 2025
# Updated      : 01 Aug 2026
# Version      : 1.6.26213
# Comments     : Original script Copyright (C) 2025 Kris Occhipinti
# TODO (Rick)  :
# License      : GNU General Public License, version 2
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
#
# You should have received a copy of the GNU General Public License along# with
# this program. If not, see <https://www.gnu.org/licenses/>.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

search_packages() {
	# Based on code by Kris Occhipinti (with minor changes)
	local package
		package="$(
		fzf -m --prompt="Enter Package Names: " \
		--preview "apt show {} 2>/dev/null" \
		--preview-window 'top:75%' < <(apt-cache pkgnames) | tr "\n" " "
	)"	# tr replaces newline with whitespace

	package="${package// /}"	# remove trailing whitespace left by tr command
	[[ "$package" ]] || { printf "Nothing selected.\n"; return 0; }
	installed "$package" && { printf "%s is already installed.\n" "$package"; return 0; }
	if default_no	"Install ${package}?"; then
		sudo_login 2
		printf "\n"
		sudo apt install "$package"
		return "$?"
	else
		printf "%s selected but not installed.\n" "$package"
		return 0
	fi
}

main() {
  local -r script="${0##*/}"
  local -r version="1.6.26213"
	local -i exit_code=0
  check_package fzf
  search_packages
	exit_code="$?"
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
