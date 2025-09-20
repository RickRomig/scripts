#!/usr/bin/env bash
##########################################################################
# Script Name  : repo-update.sh
# Description  : update cloned repositories
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 19 Sep 2025
# Last updated : 20 Sep 2025
# Version      : 1.1.25263
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
	local -r repo_dir="$1"
	if [[ -d "$repo_dir" ]]; then
		pushd "$repo_dir" >/dev/null 2>&1 || return 1
		git checkout --quiet .
		git pull --quiet
		popd >/dev/null 2>&1 || return 1
	fi
}

main() {
	local clone clones
  clones=(configs scripts i3wm-debian homepage)
  for clone in "${clones[@]}"; do
		update_clone "$HOME/Downloads/$clone"
  done
	rm "$HOME"/.local/share/logs/repo-update* >/dev/null 2>&1
	touch "$HOME"/.local/share/logs//repo-update-"$(date +'%y%m%d%H%M')" >/dev/null 2>&1
}

## Execution ##

main "$@"
