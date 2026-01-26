#!/usr/bin/env bash
##########################################################################
# Script Name  : greset.sh
# Description  : Reset most recent commit to the previous version before it's pushed to repo
# Dependencies : git
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 May 2024
# Last updated : 26 Jan 2026
# Comments     : Commits that haven't been pushed to the repository.
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

## Global Variables ##

readonly E_NOT_GIT_REPO=92

## Functions ##

git_reset() {
	local hash
	hash-"$(awk 'NR==1 {print $1}' <(git log --oneline))"
	printf "Resetting the most recent commit (%s) that has not been pushed to the remote repository to the previous version.\n" "$hash"
	git reset "$hash"
	head -n 2 <(git log --oneline)
}

main() {
  local script="${0##*/}"
	local version="2.4.26026"
	check_package git
	[[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || die "You are not in a git repositiory." "$E_NOT_GIT_REPO"
	if y_or_n "Reset last unpushed commit to the previous version?"; then
		git_reset
	else
		printf "Last commit unchanged.\n"
	fi
	over_line "$script $version"
	exit
}

## Execution ##

main "$@"
