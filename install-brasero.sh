#!/usr/bin/env bash
###############################################################################
# Script Name  : install-brasero.sh
# Description  : installs Braseo with added permisions & settings
# Dependencies : None
# Arguments    : See help() function for available options.
# Author       : Copyright © 2026, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 14 Feb 2026
# Updated      : 07 Aug 2026
# Version      : 2.0.26219
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

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

help() {
	local -r script="$1"
	local -r version="$2"
	local -ri errcode="${3:-1}"
	local -r updated="07 Aug 2026"
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

append_mimeapps() {
	local -r applications_dir=~/.local/share/applications
	local -r brasero_mimes=("x-content/blank-cd=brasero.desktop;" "x-content/blank-dvd=brasero.desktop;")
	[[ -d "$applications_dir" ]] || mkdir -p "$applications_dir"
	[[ -f "$applications_dir/mimeapps.list" ]] || touch "$applications_dir/mimeapps.list"
  printf  "Updating mimeapps.iist...\n"
	tee -a "$applications_dir/mimeapps.list" < <(printf "%s\n" "${brasero_mimes[@]}")
	grep -w brasero "$applications_dir/mimeapps.list"
	return 0
}

# Sound 'pop and click' fix. Set sound card to stay powered on all the time.
pop_and_click_fix() {
	sudo tee -a /etc/modprobe.d/alsa-base.conf >/dev/null <<< "options snd-hda-intel power_save=0 power_save_controler=N"
	return "$?"
}

install_brasero() {
	if installed brasero; then
		printf "Brasero %s is already installed.\n" "$(brasero_version)" >&2
		return "$E_INSTALLATION"
	fi
	check_dependencies
	printf "Installing Brasero CD/DVD burning application...\n"
	sudo apt-get install -y brasero brasero-common
	is_debian && sudo apt-get install -y brasero-cdrkit
	if ! installed brasero; then
		printf "%s Brasero installation failed.\n" "$RED_ERROR" >&2
		return "$E_INSTALLATION"
	fi
	set_permissions
	append_mimeapps
	pop_and_click_fix
	printf "Brasero %s installed.\n" "$(brasero_version)"
	return 0
}

remove_brasero() {
	local -r applications_dir=~/.local/share/applications
	if ! installed brasero; then
		printf "Brasero is not installed.\n" >&2
		return "$E_INSTALLATION"
	fi
	printf "Removing Braseror %s...\n" "$(brasero_version)"
	sudo apt-get remove brasero brasero-common brasero-cdrkit
	sed -i '/brasero.desktop/d' "$applications_dir/mimeapps.list"
	printf "Brasero removed.\n"
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="2.0.26219"
	local -i exit_code=0
	local -i reboot_flag="$FALSE"
	local opt OPTARG OPTIND
	local -i noOpt=1
	local -r optstr=":hir"
	while getopts "$optstr" opt; do
		case "$opt" in
			h )
				help "$script" "$version" 0 ;;
			i )
				install_brasero && reboot_flag="$TRUE" ;;
			r )
				remove_brasero ;;
			? )
				printf "%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help "$script" "$version" "$E_INVALID_ARG"
		esac
		exit_code="$?"
		noOpt=0
	done
	if (( noOpt == 1 )); then
		printf "%s No argument passed.\n" "$RED_ERROR" >&2
		help "$script" "$version" "$E_MISSING_ARG"
	fi
	shift "$(( OPTIND - 1 ))"
	over_line "$script $version"
	(( reboot_flag == 0 )) && reboot_system
	exit "$exit_code"
}

main "$@"
