#!/usr/bin/env bash
##########################################################################
# Script Name  : a-test.sh
# Description  :
# Dependencies :
# Arguments    :
# Author       : Copyright (C) 2022 Richard B. Romig, created: 07 Oct 2022
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Comments     :
# Last updated : 07 Oct 2022
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Global Variables ##

readonly _script=$(basename "$0")
readonly _version="0.1.0"
readonly _updated="07 Oct 2022"
readonly red_error="${lightred}ERROR:${normal}"

## Functions ##

usage() {
  local errcode="${1:-2}"
  cat << END_HELP
${green}Usage:${normal} $_script [argument]
${orange}Example:${normal} $_script <argument>
END_HELP
	printf "\U1F427 %s v%s (%s)\n" "$_script" "$_version" "$_updated"
  exit "$errcode"
}

check_dependencies() {
  check_package wget
}

## Execution ##

# clear


# echo -e "\U1F427 $_script v$_version ($_updated)"
printf "\U1F427 %s v%s (%s)\n" "$_script" "$_version" "$_updated"
exit
