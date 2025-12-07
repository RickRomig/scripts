#!/usr/bin/env bash
##########################################################################
# Script Name  : grevert.sh
# Description  : Revert most recent commit to the previous version after it's been pushed to repo
# Dependencies : git
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 May 2024
# Last updated : 22 Jul 2025
# Comments     : Commits that have been pushed to the repository.
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

## Functions ##

git_revert() {
	local hash
	hash=$(git log --oneline | head -n 1 | cut -d' ' -f1)
	printf "Reverting the most recent pushed commit to the previous version.\n"
	git revert "$hash" --no-edit
	git log --oneline | head -n 2
	git push
}

main() {
  local script="${0##*/}"
	local version="2.2.25203"
	check_package git
	[[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || die "You are not in a git repositiory." 1
	if y_or_n "Reset last commit (pushed) to the previous version?"; then
		git_revert
	else
		printf "Last commit unchanged.\n"
	fi
	over_line "$script $version"
	exit
}

## Execution ##

main "$@"
