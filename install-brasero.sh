#!/usr/bin/env bash
###############################################################################
# Script Name  : install-brasero.sh
# Description  : installs Braseo with added permisions
# Dependencies :
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 14 Feb 2026
# Updated      : 10 Jul 2026
# Comments     : Thanks to Joe Collins and Matt Hartley for the fix to the permissions problem.
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify# it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or# (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of# MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

## Source function library ##
# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

help() {
	local -r script="$1"
	local -r version="$2"
	local -r errcode="${3:-1}"
	local -r updated="10 Jul 2026"
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
	return "$?"
}

brasero_version() {
	awk '/^ii/ {print $3}' < <(dpkg -l brasero) | sed 's/[~+-].*//'
	return 0
}

#  Set permissions to enable audio CD writing
set_permissions() {
  printf "Setting permissions...\n"
  sudo chmod -v 4711 /usr/bin/cdrdao
  sudo chmod -v 4711 /usr/bin/wodim
  sudo chmod -v 0755 /usr/bin/growisofs
	return 0
}

add_mimeapps() {
	local -r applications_dir=~/.local/share/applications
	[[ -d "$applications_dir" ]] || mkdir -p "$applications_dir"
	[[ -f "$applications_dir/mimeapps.list" ]] || touch "$applications_dir/mimeapps.list"
	local -r set_brasero=("x-content/blank-cd=brasero.desktop;" "x-content/blank-dvd=brasero.desktop;")
  printf  "Updating mimeapps.iist...\n"
	tee -a "$applications_dir/mimeapps.list" < <(printf "%s\n" "${set_brasero[@]}")
	grep -w brasero "$applications_dir/mimeapps.list"
	return 0
}

# Sound 'pop and click' fix. Set sound card to stay powered on all the time
pop_and_click() {
	sudo tee -a /etc/modprobe.d/alsa-base.conf >/dev/null <<< "options snd-hda-intel power_save=0 power_save_controler=N"
	return "$?"
}

install_brasero() {
	printf "Installing Brasero CD/DVD burning application...\n"
	sudo apt-get install -y brasero brasero-common
	is_debian && sudo apt-get install -y brasero-cdrkit
	if ! installed brasero; then
		printf "%s Brasero installation failed.\n" "$RED_ERROR" >&2
		return "$E_INSTALLATION"
	fi
	check_dependencies
	set_permissions
	add_mimeapps
	pop_and_click
	printf "Brasero %s installed.\n" "$(brasero_version)"
	return 0
}

remove_brasero() {
	local -r applications_dir=~/.local/share/applications
	printf "Removing Braseror %s...\n" "$(brasero_version)"
	sudo apt-get remove brasero brasero-common brasero-cdrkit
	sed -i '/brasero.desktop/d' "$applications_dir/mimeapps.list"
	printf "Brasero removed.\n"
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="1.6.26191"
	local -i exit_code=0
	local opt  OPTARG OPTIND
	local -i noOpt=1
	local -r optstr=":hir"
	while getopts "$optstr" opt; do
		case "$opt" in
			h )
				help "$script" "$version" 0
				;;
			i )
				if installed brasero; then
					printf "Brasero %s is already installed.\n" "$(brasero_version)"
				else
					install_brasero
				fi
				;;
			r )
				if installed brasero; then
					remove_brasero
				else
					printf "Brasero is not installed.\n"
				fi
				;;
			? )
				printf "%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help "$script" "$version" "$E_INVALID_ARG"
		esac
		exit_code="$?"
		noOpt=0
	done
	[[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$RED_ERROR" >&2; help "$script" "$version" "$E_MISSING_ARG"; }
	shift "$(( OPTIND - 1 ))"
	over_line "$script $version"
	[[ $exit_code -eq 0 ]] && reboot_system
	exit "$exit_code"
}

main "$@"
