#!/usr/bin/env bash
##########################################################################
# Script Name  : install-brasero.sh
# Description  : installs Braseo with added permisions
# Dependencies :
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 14 Feb 2026
# Updated      : 14 Feb 2026
# Version      : 1.0.26045
# Comments     : Thanks to Joe Collins and Matt Hartley for the fix for the permissions problem.
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
  exit 81
fi

## Global Variables ##

readonly script="${0##*/}"
readonly version="1.0.26045"
EC=0

## Functions ##

help() {
	local errcode="${1:-1}"
	local -r updated="14 Feb 2026"
	cat << _HELP_
${orange}$script${normal} $version, Upated: $updated
Installs Brasero CD/DVD writeer

${green}Usage:${normal} $script [-hir]
${orange}Available options:${normal}
	-h	Show this help message and exit.
	-i	Install Brasero.
	-r	Remove Brasero.
_HELP_
  exit "$errcode"
}

check_dependencies() {
  local packages=( cdrdao growisofs wodim )
  check_packages "${packages[@]}"
}

brasero_version() {
	awk '/ii/ {print $3}' <(dpkg -l brasero) | sed 's/[~+-].*//'
}

#  Set permissions to enable audio CD writing
set_permissions() {
  echo "Setting permissions..."
  sudo chmod -v 4711 /usr/bin/cdrdao
  sudo chmod -v 4711 /usr/bin/wodim
  sudo chmod -v 0755 /usr/bin/growisofs
}

mimeapps_list_add() {
  local -r mimeapps_list="$HOME/.local/share/applications/mimeapps.list"
  if [[ -f "$HOME/$mimeapps_list" ]]; then
    if grep -qw 'brasero' "$HOME/$mimeapps_list"; then
      echo "Updating mimeapps.iist..."
      {
        echo "x-content/blank-cd=brasero.desktop;"
        echo "x-content/blank-dvd=brasero.desktop;"
      } >> "$mimeapps_list"
    fi
  fi
}

# Sound 'pop and click' fix. Set sound card to stay powered on all the time
pop_and_click() {
	echo "options snd-hda-intel power_save=0 power_save_controler=N'" | tee -a /etc/modprobe.d/alsa-base.conf >/dev/null
}

install_brasero() {
	printf "Installing Brasero CD/DVD burning application...\n"
	sudo apt-get install -y brasero brasero-common
	is_debian && sudo apt-get install -y brasero-cdrkit
	if ! grep -q '^ii' <(dpkg -l brasero 2>/dev/null); then
		printf "%s Brasero installation failed.\n" "$RED_ERROR" >&2
		EC="$E_INSTALLATION"
		return
	fi
	check_dependencies
	set_permissions
	mimeapps_list_add
	pop_and_click
	printf "Brasero %s installed.\n" "$(brasero_version)"
}

remove_brasero() {
	printf "Removing Braseror %s...\n" "$(brasero_version)"
	sudo apt-get remove brasero
	printf "Brasero removed.\n"
}

main() {
	local noOpt opt optstr OPTARG OPTIND
	noOpt=1
	optstr=":hir"
	while getopts "$optstr" opt; do
		case "$opt" in
			h )
				help 0
			;;
			i )
				if exists brasero; then
					printf "Brasero %s is already installed.\n" "$(brasero_version)"
				else
					install_brasero
				fi
				;;
			r )
				if exists brasero; then
					remove_brasero
				else
					printf "Brasero is not installed.\n"
				fi
				;;
			? )
				printf "%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help "$E_INVALID_ARG"
		esac
		noOpt=0
	done
	[[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$RED_ERROR" >&2; help "$E_MISSING_ARG"; }
	shift "$(( OPTIND - 1 ))"
	over_line "$script $version"
	[[ "$EC" -eq 0 ]] && reboot_system
	exit "$EC"
}

## Execution ##

main "$@"
