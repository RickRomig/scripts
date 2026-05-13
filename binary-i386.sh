#!/usr/bin/env bash
##########################################################################
# Script Name  : binary-i386.sh
# Description  : Removes support for 32-bit (i386) architecture
# Dependencies : None
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 15 Apr 2026
# Last updated : 13 May2026
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
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

intro_message() {
echo "Error message that sometimes appears when updating Google Chrome..."
echo "Skipping acquire of configured file 'main/binary-i386' as repository"
echo "\"https://dl.google.com/linux/chrome-stable/deb stable InRelease\""
echo "doesn't support architecture 'i386'"
}

check_i386_arch() {
	local foreign_arch
	foreign_arch=$(dpkg --print-foreign-architectures)
	[[ $foreign_arch == "i386" ]] && return "$TRUE" || return "$FALSE"
}

check_amd64_arch() {
	local  native_arch
	native_arch=$(dpkg --print-architecture)
	printf "%+4sNative architecture is %s.\n" "" "$native_arch"
	[[ $native_arch == "amd64" ]] && return "$TRUE" || return "$FALSE"
}

remove_i386_arch() {
	local  native_arch num_386
	printf "\nConfirm that 64-bit with multiarch is enabled...\n"
	if check_i386_arch; then
		printf "%+4s32-bit support has been added.\n" ""
	else
		printf "%+4s32-bit support has not been added.\n" ""
	fi
	printf "Confirm native architecture...\n"
	check_amd64_arch || return
	num_386=$(grep -c 386 < <(dpkg --get-selections))
	if [[ $num_386 -gt 0 ]]; then
		printf "Number of 32-bit packages = %d\n" "$num_386"
		printf "32-bit applicaitons:\n"
		grep 386 < <(dpkg --get-selections)
		return
	fi
	check_i386_arch || return
	sudo_login 2
	printf "%+4sRemoving i386 architecture support...\n" ""
	grep i386 < <(sudo dpkg --remove-architecture i386)
	echo "${PIPESTATUS[@]}"
	printf "i386 support removed.\n"
}

main() {
  local -r script="${0##*/}"
  local -r version="2.0.26133"
  intro_message
  remove_i386_arch
  over_line "$script $version"
	exit
}

## Execution ##

main "$@"
