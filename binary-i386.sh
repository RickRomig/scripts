#!/usr/bin/env bash
###############################################################################
# Script Name  : binary-i386.sh
# Description  : Removes support for 32-bit (i386) architecture
# Dependencies : None
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 15 Apr 2026
# Last updated : 09 Jul 2026
# Comments     : Fixes main/binary-i386 error message for Google Chrome update
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A  PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

intro_message() {
	cat <<- _INTRO_
	While updating Google Chrome using apt, the following message may appear:
	${green}Skipping acquire of configured file 'main/binary-i386' as repository
	"https://dl.google.com/linux/chrome-stable/deb stable InRelease"
	doesn't support architecture 'i386'${normal}
	_INTRO_
}

check_google_chrome() {
	installed google-chrome-stable && return "$TRUE"
	printf "\nGoogle Chrome is not installed. Operation canceled.\n"
	return "$FALSE"
}

check_i386_arch() {
	grep -q 'i386' < <(dpkg --print-foreign-architectures) && return "$TRUE" || return "$FALSE"
}

check_amd64_arch() {
	local native_arch
	native_arch=$(dpkg --print-architecture)
	printf "%+4sNative architecture is %s.\n" "" "$native_arch"
	[[ $native_arch == "amd64" ]] && return "$TRUE" || return "$FALSE"
}

remove_i386_arch() {
	local num_386
	printf "\nConfirm that 64-bit with multiarch is enabled...\n"
	check_amd64_arch || return "$?"
	if check_i386_arch; then
		printf "%+4s32-bit support has been added.\n" ""
	else
		printf "%+4s32-bit support has not been added.\n" ""
		return 0
	fi
	num_386=$(grep -c 386 < <(dpkg --get-selections))
	if [[ $num_386 -gt 0 ]]; then
		printf "\n32-bit applications:\n"
		grep 386 < <(dpkg --get-selections)
		printf "32-bit architecture support cannot be removed.\n"
		return 1
	fi
	printf "%+4sNo 32-bit packages installed.\n" ""
	check_i386_arch || return "$?"
	sudo_login 2
	printf "%+4sRemoving i386 architecture support...\n" ""
	grep i386 < <(sudo dpkg --remove-architecture i386)
	echo "${PIPESTATUS[@]}"
	printf "i386 support removed.\n"
	return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="2.2.26190"
	local -i exit_code=0
  intro_message
	check_google_chrome && remove_i386_arch
	exit_code="$?"
  over_line "$script $version"
	exit "$exit_code"
}

main "$@"
