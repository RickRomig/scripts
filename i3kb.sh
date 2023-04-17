#!/usr/bin/env bash
##########################################################################
# Script Name  : i3bindings.sh
# Description  : Displays i3 keybindings
# Dependencies : None
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Apr 2023
# Last updated : 16 Apr 2023
# Comments     : Install with bindings.list in ~/.config/i3/
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

_script=$(basename "$0"); readonly _script
readonly _version="0.1.0"
readonly _updated="16 Apr 2023"

## Functions ##

show_bindings() {
	local binding_path=$HOME"/.config/i3"
	local binding_list="bindings.list"
	(printf "Binding|Action|Binding|Action\n"; less "$binding_path/$binding_list") | column -ts "|"
	}

## Execution ##

clear
printf "%s v%s (%s)\n" "$_script" "$_version" "$_updated"
show_bindings
exit
