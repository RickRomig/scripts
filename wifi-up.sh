#!/usr/bin/env bash
###############################################################################
# Script Name  : wifi-up.sh
# Description  : Checks wifi connection & if down, bring it up if toggled on.
# Dependencies : none
# Arguments    : none
# Author       : Richard B. Romig, 21 Jan 2022
# Email        : rick.romig@gmail.com
# Comments     :
# Last updated : 21 Jan 2022
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

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

_script=$(basename "$0"); readonly _script
readonly _version="0.1.2"
readonly _updated="04 Apr 2023"

echo "$_script v$_version ($_updated)"

# check_package iwgetid
# iw ?

# bring up wireless interface

# Extract wireless interface
# wifi_int=$(/usr/bin/nmcli dev | awk '/wifi/ {print $1}')
wifi_int=$(ip addr show | awk '/: wl/ {print $2}' | sed 's/:$//')
# wifi_int=$(iwgetid | awk '{ print $1 }')
[ -z "$wifi_int" ] && die "No wireless interface detected."

wifi_ip=$(/sbin/ip -o -4 addr show | awk -v name="$wifi_int" '$0~name {print $4}')
[ -z "$wifi_ip" ] && echo "No IP address found. Is $wifi_int up?"

# Check if interface is down and bring up if not
/sbin/ip link show "$wifi_int" | grep 'DOWN' && sudo /sbin/ip link set "$wifi_int" up

# Check again. If down, have user check if device is toggled on
/sbin/ip link show "$wifi_int" | grep 'DOWN' && die "Make sure WiFi is toggled on."

# Show wireless IP address
wifi_ip=$(/sbin/ip -o -4 addr show | awk -v name="$wifi_int" '$0~name {print $4}')
if [ -n "$wifi_ip" ]; then
  leave "IP = $wifi_ip"
else
  die "No IP address found. Begin troubleshooting."
fi
