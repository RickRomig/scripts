#!/usr/bin/env bash
###############################################################################
# Script Name  : scan-range.sh
# Description  : Scans a range of IP addresses to determine if online.
# Dependencies : arping (iputils-arping)
# Arguments    : Beginning and last octets of range to be scanned.
# Author       : Richard B. Romig, 27 Jul 2022
# Email        : rick.romig@gmail.com
# Comments     : Adapted from a script by Dave McKay at howtogeek.com
# TODO (Rick)  : 
# License      : GNU General Public License, version 2.0
###############################################################################

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
readonly _version="0.1.0"
readonly _updated="27 Jul 2022"

## Execution ##

box "$_script $_version ($_updated)"

if [ $# -lt 2 ]; then
	printf "Enter two integers for the range of addresses.\n" >&2
	printf "Example: %s 15 20\n" >&2 "$_script"
	exit 1
elif [[ "$1" =~ ^[0-9]+$ && "$2" =~ ^[0-9]+$ ]] 2>/dev/null; then
	for ((device=$1; device<=$2; device++))
	do
  	if arping -c 1 "$localnet.$device" | grep -E "0 response|0 packets received" > /dev/null
		then
    	printf "%s.%s didn't respond.\n" "$localnet" "$device"
  	else
    	printf "%s.%s responded.\n" "$localnet" "$device"
  	fi
	done
else
	printf "Arguments must be integer values.\n"
	printf "Example: %s 15 20\n" >&2 "$_script"
	exit 1
fi
leave "" 
