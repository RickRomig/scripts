#!/usr/bin/env bash
##########################################################################
# Script Name  : grevert.sh
# Description  : Revert most recent commit to the previous version after it's been pushed to repo
# Dependencies : git
# Arguments    : none
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 May 2024
# Last updated : 05 May 2026
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

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

git_revert() {
	local hash
	hash="$(awk 'NR==1 {print $1}' < <(git log --oneline))"
	printf "Reverting the most recent pushed commit (%s) to the previous version.\n" "$hash"
	git revert "$hash" --no-edit
	head -n 2 <(git log --oneline)
	git push
}

main() {
  local -r script="${0##*/}"
	local -r version="2.4.26125"
	local -r E_NOT_GIT_REPO=101
	check_package git
	[[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || die "You are not in a git repositiory." "$E_NOT_GIT_REPO"
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
