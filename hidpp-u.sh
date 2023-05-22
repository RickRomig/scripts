#!/usr/bin/env bash
##########################################################################
# Script Name  : hidpp-u.sh
# Description  : Displays wireless mouse model name and battery charge.
# Dependencies : upower
# Arguments    : none
# Author       : Copyright (C) 2021, Richard B. Romig, 21 Mar 2021
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
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

_script=$(basename "$0"); readonly _script
readonly _version="0.2.1"
readonly _updated="22 May 2023"

## Execution ##

check_package upower

if /usr/bin/upower -e | grep -q mouse_hidpp_battery; then
  hidpp_data=$(/usr/bin/upower -i "$(/usr/bin/upower -e | grep hidpp)")
  printf "%-17s%-7s%-8s%s\n" "Device" "Model" "Charge" "Serial number"
  printf "%-17s%-7s%-8s%s\n" "$(echo "$hidpp_data"| awk '/native-path/ {print $NF}')" \
  "$(echo "$hidpp_data"| awk '/model/ {print $NF}')" \
  "$(echo "$hidpp_data"| awk '/percentage/ {print $NF}')" \
  "$(echo "$hidpp_data"| awk '/serial/ {print $NF}')"
else
  printf "No hidpp battery found.\n"
fi
printf "%s v%s (%s)\n" "$_script" "$_version" "$_updated"
exit
