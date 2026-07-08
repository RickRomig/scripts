#!/usr/bin/env bash
################################################################################
# Script Name  : update-clones.sh
# Description  : update cloned repositories using git pull
# Dependencies : git
# Arguments    : None
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 13 Aug 2025
# Last updated : 08 Jul 2026
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
################################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
################################################################################

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

update_clone() {
	local -r clone="$1"
	local -r repo_log="$2"
	local repo_dir="$HOME/Downloads/$clone"
	[[ -d "$HOME/$clone" ]] && repo_dir="$HOME/$clone"
	{
		if [[ -d "$repo_dir" ]]; then
			pushd "$repo_dir" || return "$E_POPD_PUSHD"
			git checkout .
			git pull
			popd >/dev/null 2>&1 || return "$E_POPD_PUSHD"
			printf "\n"
		else
			printf "~ %s repository ~\nHas not been cloned to this computer.\n~\n" "$clone"
		fi
	} | tee -a "$repo_log"
	return "$?"
}

loop_clones() {
	local -r script="$1"
	local -r version="$2"
	local -r log_dir=~/.local/share/logs
	local -r repo_log="$log_dir/repo-update.log"
  local -r clones=(configs scripts i3wm-debian homepage)
	local clone
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
	printf "%(%F %R)T (%s %s)\n" -1 "$script" "$version" > "$repo_log"
  for clone in "${clones[@]}"; do
		update_clone "$clone" "$repo_log"
  done
	return "$?"
}

main() {
  local -r script="${0##*/}"
  local -r version="4.0.26189"
	local -i exit_code=0
  check_package git
  printf "Updating cloned repositories...\n\n"
	loop_clones "$script" "$version"
	exit_code="$?"
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
