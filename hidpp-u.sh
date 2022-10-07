#!/usr/bin/env bash
##########################################################################
# Script Name  : hidpp-u.sh
# Description  : Displays wireless mouse model name and battery charge.
# Dependencies : upower
# Arguments    : none
# Author       : Richard B. Romig, 21 Mar 2021
# Email        : rick.romig@gmail.com
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Variables ##

readonly _script=$(basename "$0")
readonly _version="0.1.7"
readonly _updated="23 Sep 2022"

## Functions ##

is_hidpp() {
  hidpp=$(/usr/bin/upower -e | grep mouse_hidpp_battery)
  [[ -n "$hidpp" ]] && return "$TRUE" || return "$FALSE"
}

cleanup() {
  [[ -f "$hidpp_data" ]] && rm "$hidpp_data"
}

## Execution ##

check_package upower

if is_hidpp; then
  hidpp_data=$(mktemp) || die "Failed to create temporary file." 1
  trap cleanup EXIT
  /usr/bin/upower -i "$(/usr/bin/upower -e | grep hidpp)" > "$hidpp_data"
  printf "%-17s%-7s%-8s%s\n" "Device" "Model" "Charge" "Serial number"
  printf "%-17s%-7s%-8s%s\n" "$(awk '/native-path/ {print $NF}' "$hidpp_data")" \
  "$(awk '/model/ {print $NF}' "$hidpp_data")" \
  "$(awk '/percentage/ {print $NF}' "$hidpp_data")" \
  "$(awk '/serial/ {print $NF}' "$hidpp_data")"
else
  printf "No hidpp battery found.\n"
fi
printf "%s v%s (%s)\n" "$_script" "$_version" "$_updated"
exit
