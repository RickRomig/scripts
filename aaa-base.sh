#!/usr/bin/env bash
##########################################################################
# Script Name  : aaa-base.sh
# Description  : Template for a new script.
# Dependencies : functionlib
# Arguments    : None
# Author       : Richard B. Romig, 04 May 2021
# Email        : rick.romig@gmail.com
# Comments     :
# Last updated : 25 Sep 2022
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

## Variables ##

readonly _script=$(basename "$0")
readonly _version="0.1.0"
readonly _updated="25 Sep 2022"

## Functions ##

usage() {
  local errcode="${1:-2}"
  echo "Usage: $_script [argument]"
  echo "$_script argument"
  exit "$errcode"
}

## Execution ##

# clear
echo -e "\U1F427 ${lightyellow}$_script${normal} v$_version ($_updated)"
# printf "\U1F427 %s v%s (%s)\n" "$_script" "$_version" "$_updated"
print_line "x" 35
printf "Local IP: %s.%s\n" "$localnet" "$(local_ip)"
printf " Gateway: %s.1\n" "$localnet"
box "Distribution: $(get_distribution)"
under_line "Generic script template." 
printf "MOTD: "
leave ""
# die
