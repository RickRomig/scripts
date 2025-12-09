#!/usr/bin/env bash
##########################################################################
# Script Name  : repo-update.sh
# Description  : update cloned repositories
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 19 Sep 2025
# Last updated : 08 Dec 2025
# Comments     : Run as a daily cron job from ~/.local/bin/
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

## Functions ##

update_clone() {
	local -r clone="$1"
	local -r repo_log="$2"
	local repo_dir="$HOME/Downloads/$clone"
	[[ -d "$HOME/$clone" ]] && repo_dir="$HOME/$clone"
	{
		if [[ -d "$repo_dir" ]]; then
			pushd "$repo_dir" || return 1
			git checkout .
			git pull
			popd || return 1
		else
			printf "%s has not been cloned to this computer.\n" "$clone"
		fi
	} >> "$repo_log"
}

main() {
	local clone clones
	local -r script="${0##*/}"
	local -r version="2.0.25342"
	local -r log_dir="$HOME/.local/share/logs"
	local -r repo_log="$log_dir/repo=updated.log"
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
	printf "%s %s\n" "$script" "$version" > "$repo_log"
  clones=(configs scripts i3wm-debian homepage)
  for clone in "${clones[@]}"; do
		update_clone "$clone" "$repo_log"
  done
}

## Execution ##

main "$@"
