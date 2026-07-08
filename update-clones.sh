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

update_clones() {
	local -r script="$1"
	local -r version="$2"
	local -r log_dir=~/.local/share/logs
	local -r repo_log=repo-update.log
  local -r clones=(configs scripts i3wm-debian homepage)
	local clone clone_dir
	[[ -d "$log_dir" ]] || mkdir -p "$log_dir"
	printf "%(%F %R)T (%s %s)\n" -1 "$script" "$version" > "$log_dir/$repo_log"
		{
			for clone in "${clones[@]}"; do
				clone_dir="$HOME/Downloads/$clone"
				[[ -d "$HOME/$clone" ]] && clone_dir="$HOME/$clone"
				if [[ -d "$clone_dir" ]]; then
					pushd "$clone_dir" >/dev/null 2>&1 || return "$E_POPD_PUSHD"
					printf "~ %s repository ~\n" "${clone^^}"
					git checkout .
					git pull
					popd >/dev/null 2>&1 || return "$E_POPD_PUSHD"
					printf "\n"
				else
					printf "~ %s repository ~\nHas not been cloned to this computer.\n~\n" "${clone^^}"
				fi
			done
		} | tee -a "$log_dir/$repo_log"
	return 0
}

validIP() {
  local local_host="${HOSTNAME:-$(hostname)}"
	case "$local_host" in
		hp-800g2-sff|hp-850-g3|hp-8300-usdt ) return "$FALSE" ;;
		* ) return "$TRUE"
	esac
}

main() {
  local -r script="${0##*/}"
  local -r version="5.0.26189"
	local -i exit_code=0
	printf "%sUpdating cloned repositories...%s\n" "$orange" "$normal"
	if validIP; then
		check_package git
		update_clones "$script" "$version"
		exit_code="$?"
	else
		exit_code="$?"
		printf "Main repository - Nothing to do.\n"
	fi
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
