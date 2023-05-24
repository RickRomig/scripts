#!/usr/bin/env bash
##########################################################################
# Script Name  : i3kb.sh
# Description  : Displays i3 keybindings
# Dependencies : curl
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Apr 2023
# Last updated : 18 May 2023
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
readonly _version="0.1.2"
readonly _updated="18 May 2023"
readonly i3_dir=$HOME"/.config/i3"

## Functions ##

copy_bindings() {
	local list="$1"
	local gitea_url="http://192.168.0.16:3000/Nullifidian/i3debian/raw/branch/main/.config/i3"
	curl -so "$i3_dir/$list" "$gitea_url/$list"
}

show_bindings() {
	local bindings="bindings.list"
	[[ -f "$i3_dir/$bindings" ]] || copy_bindings "$bindings"
	(printf "Binding|Action|Binding|Action\n"; less "$i3_dir/$bindings") | column -ts "|"
}

## Execution ##

check_package curl
clear
printf "%s v%s (%s)\n" "$_script" "$_version" "$_updated"
show_bindings
exit
