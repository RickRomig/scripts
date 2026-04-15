#!/usr/bin/env bash
##########################################################################
# Script Name  : binary-i386.sh
# Description  : Removes support for 32-bit (i386) architecture
# Dependencies : None
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 15 Apr 2026
# Last updated : 15 Apr 2026
# Comments     : Fixes main/binary-i386 error message for Google Chrome update
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

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

intro_message() {
echo "Error message that sometimes appears when updating Google Chrome..."
echo "Skipping acquire of configured file 'main/binary-i386' as repository"
echo "\"https://dl.google.com/linux/chrome-stable/deb stable InRelease\""
echo "doesn't support architecture 'i386'"
}

remove_i386_arch() {
	local foreign_arch native_arch num_386
	printf "\nConfirm that 64-bit with multiarch is enabled.\n"
	foreign_arch=$(dpkg --print-foreign-architectures)
	if [[ $foreign_arch == "i386" ]]; then
		printf "32-bit support has been added.\n"
	else
		printf "32-bit support has not been added.\n"
		return
	fi
	printf "Confirm native architecture...\n"
	native_arch=$(dpkg --print-architecture)
	printf "Native architecture is %s.\n" "$native_arch"
	[[ $native_arch != "amd64" ]] && return
	num_386=$(grep -c 386 < <(dpkg --get-selections))
	printf "Number of 32-bit packages = %d\n" "$num_386"
	if [[ $num_386 -eq 0 ]]; then
		printf "Removing support for i386 architecture...\n"
		# grep i386 < <(sudo dpkg --remove-architecture i386)
		printf "i386 support removed.\n"
	else
		printf "32-bit applications are present.\n"
		dpkg --get-selections | grep 386
	fi
}

main() {
  local -r script="${0##*/}"
  local -r version="1.0.26105"
  intro_message
  remove_i386_arch
  over_line "$script $version"
	exit
}

## Execution ##

main "$@"
