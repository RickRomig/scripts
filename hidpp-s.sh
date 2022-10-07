#!/usr/bin/env bash
##########################################################################
# Script Name  : hidpp-s.sh
# Description  : Displays status of wireless mouse battery.
# Dependencies : none
# Arguments    : none
# Author       : Richard B. Romig, 21 Mar 2021
# Email        : rick.romig@gmail.com
# Comments     : Uses data from /sys/class/power_supply/hidpp_battery_0
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
readonly _version="0.1.8"
readonly _updated="23 Sep 2022"
readonly hidpp_path="/sys/class/power_supply/hidpp_battery_0"

## Execution ##

if [[ -d "$hidpp_path" ]]; then
  printf "%-17s%-15s%-7s%-8s%s\n" "Device" "Manufacturer" "Model" "Charge" "Serial number"
  printf "%-17s%-15s%-7s%-8s%s\n" "$(basename "$hidpp_path")" \
  "$(cat "$hidpp_path/manufacturer")" "$(cat "$hidpp_path/model_name")" \
  "$(cat "$hidpp_path/capacity")%" "$(cat "$hidpp_path/serial_number")"
else
  printf "No hidpp battery found.\n"
fi
printf "%s v%s (%s)\n" "$_script" "$_version" "$_updated"
exit
