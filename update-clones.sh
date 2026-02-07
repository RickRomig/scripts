#!/usr/bin/env bash
##########################################################################
# Script Name  : update-clones.sh
# Description  : update cloned repositories using git pull
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 13 Aug 2025
# Last updated : 20 Sep 2025
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
  exit 81
fi

## Functions ##

update_clone() {
	local -r clone="$1"
	local repo_dir="$HOME/Downloads/$clone"
	[[ -d "$HOME/$clone" ]] && repo_dir="$HOME/$clone"
	if [[ ! -d "$repo_dir" ]]; then
		pushd "$repo_dir" || { EC="$E_POPD_PUSHD"; return; }
		git checkout .
		git pull
		popd >/dev/null 2>&1 || { EC="$E_POPD_PUSHD"; return; }
		printf "\n"
	else
		printf "The %s repository has not been cloned to this computer.\n\n" "${repo_dir##*/}"
	fi
}

main() {
	EC=0
	local clone clones
  local -r script="${0##*/}"
  local -r version="2.2.25339"
  clones=(configs scripts i3wm-debian homepage)
  check_package git
  printf "Updating cloned repositories...\n\n"
  for clone in "${clones[@]}"; do
		update_clone "$clone"
  done
  over_line "$script $version"
  exit "$EC"
}

## Execution ##

main "$@"
