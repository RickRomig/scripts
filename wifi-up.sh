#!/usr/bin/env bash
##########################################################################
# Script Name  : wifi-up.sh
# Description  : Checks wifi connection & if down, bring it up.
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2022, Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 21 Jan 2022
# Updated      : 21 Jul 2025
# Comments     :
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
  exit 1
fi

set -eu

## Functions ##

get_wifi_interface() {
  local wifi_int
  wifi_int=$(ip addr show | awk '/: wl/ {print $2}' | sed 's/:$//')
  echo "$wifi_int"
}

get_ip_address() {
  local wifi_ip wifi_int
  wifi_int="$1"
  wifi_ip=$(/sbin/ip -o -4 addr show | awk -v name="$wifi_int" '$0~name {print $4}')
  echo "$wifi_ip"
}

show_wifi_ip() {
  local wifi_int wifi_ip
  wifi_int=$(get_wifi_interface)
  if [[ "$wifi_int" ]]; then
    wifi_ip=$(get_ip_address "$wifi_int")
    if [[ "$wifi_ip" ]]; then
      printf "Wireless IP - %s\n" "$wifi_ip"
    else
      printf "No wireless IP address found. Is %s up?\n" "$wifi_int"
      printf "Checking if interface is down and trying to bring it up if not.\n"
      /sbin/ip link show "$wifi_int" | grep 'DOWN' && sudo /sbin/ip link set "$wifi_int" up
      printf "Checking again. If down, check if device is toggled on.\n"
      /sbin/ip link show "$wifi_int" | grep 'DOWN' && printf "Make sure WiFi is toggled on.\n" >&2
      wifi_ip=$(get_ip_address "$wifi_int")
      if [[ "$wifi_ip" ]]; then
        printf "Wireless IP - %s\n" "$wifi_ip"
      else
        printf "No IP address found. Begin troubleshooting.\n" >&2
      fi
    fi
  else
    printf "No wireless interface found.\n"  >&2
  fi
}

main() {
  local script="${0##*/}"
  local -r version="3.0.25202"
  show_wifi_ip
  over_line "$script $version" "-"
  exit
}

## Execution ##

main "$@"
