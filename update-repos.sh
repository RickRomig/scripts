#!/usr/bin/env bash
##########################################################################
# Script Name  : update-repos.sh
# Description  : update cloned repositories using git pull
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 13 Aug 2025
# Last updated : 31 Aug 2025
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
  exit 1
fi

# set -eu

## Functions ##

pull_configs() {
	local -r repo_dir="$HOME/Downloads/configs"
	git_pull_repo "$repo_dir"
}

pull_i3wm_debian() {
	local repo_dir="$HOME/i3wm-debian"
	[[ -d "$repo_dir" ]] || repo_dir="$HOME/Downloads/i3wm-debian"
	git_pull_repo "$repo_dir"
}

pull_scripts() {
	local -r repo_dir="$HOME/Downloads/scripts"
	git_pull_repo "$repo_dir"
}

pull_homepage() {
	local repo_dir="$HOME/Downloads/homepage"
	git_pull_repo "$repo_dir"
}

git_pull_repo() {
	local -r repo_dir="$1"
	if [[ -d "$repo_dir" ]]; then
		pushd "$repo_dir" || die "pushd failed"
		git checkout .
		git pull
		popd >/dev/null 2>&1 || die "popd failed"
		printf "\n"
	else
		printf "The %s repository has not been cloned to this computer.\n\n" "${repo_dir##*/}"
	fi
}

main() {
  local -r script="${0##*/}"
  local -r version="1.2.25243"
  check_package git
  printf "Updating cloned repositories...\n\n"
  pull_configs
  pull_scripts
  pull_i3wm_debian
	pull_homepage
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
