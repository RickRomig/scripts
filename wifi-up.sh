#!/usr/bin/env bash
###############################################################################
# Script Name  : wifi-up.sh
# Description  : Checks wifi connection & if down, bring it up.
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2022, Richard B. Romig, LudditeGeek@Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 21 Jan 2022
# Updated      : 28 Jun 2024
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Variables ##

_script=$(basename "$0"); readonly _script
readonly _version="2.0.24180"

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

## Execution ##

box "$_script v$_version" "*"
echo ""

wifi_int=$(get_wifi_interface)
[[ "$wifi_int" ]] || die "No wireless interface found." 1

wifi_ip=$(get_ip_address "$wifi_int")
if [[ "$wifi_ip" ]]; then
  leave "Wireless IP = $wifi_ip"
else
  echo "No wireless IP address found. Is $wifi_int up?"
  # Check if interface is down and bring up if not
  /sbin/ip link show "$wifi_int" | grep 'DOWN' && sudo /sbin/ip link set "$wifi_int" up
  # Check again. If down, have user check if device is toggled on
  /sbin/ip link show "$wifi_int" | grep 'DOWN' && die "Make sure WiFi is toggled on." 1
  # Show wireless IP address
  wifi_ip=$(get_ip_address "$wifi_int")
  [[ "$wifi_ip" ]] && leave "Wireless IP = $wifi_ip"
fi
die "No IP address found. Begin troubleshooting." 1
