#!/usr/bin/env bash
##########################################################################
# Script Name  : kitty-kb.sh
# Description  : Displays kitty keybindings
# Dependencies : None
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 25 Apr 2023
# Last updated : 25 Apr 2023
# Comments     : Install with kitty-bindings.list in ~/.config/kitty/
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
readonly _updated="25 Apr 2023"

## Functions ##

show_bindings() {
	local binding_path=$HOME"/.config/kitty"
	local binding_list="kitty-bindings.list"
	(printf "Binding|Action\n"; less "$binding_path/$binding_list") | column -ts "|"
	}

## Execution ##

clear
printf "%s v%s (%s)\n" "$_script" "$_version" "$_updated"
show_bindings
exit
