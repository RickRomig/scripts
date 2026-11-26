#!/usr/bin/env bash
###############################################################################
# Script Name  : no-flatpak.sh
# Description  : Enable/disable Flatpaks in a Debian or Ubuntu-based system.
# Dependencies : None
# Arguments    : [-dehs] (See help function)
# Author       : Copyright (C) 2024, Richard B. Romig, MosfaNet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 02 Mar 2024
# Updated      : 25 Nov 2026
# Version      : 2.0.26329
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify  it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/files/functionlib.bash
. ~/bin/files/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

help() {
	local -ri errcode="${1:-1}"
	local -r updated="25 Nov 2026"
	cat <<- _HELP_
	${orange}$script${normal} $version, Updated $updated
	Disables/Enables Flatpak support.

	${green}Usage:${normal} $script [-dehs]
	${orange}OPTIONS:${normal}
	-d    Disable the installation of flatpak and flatpak packages
	-e    Enable the installation of flatpak and flatpak packages
	-h    Show this help message and exit
	-s    Status of flatpak and flatpak package installation
	_HELP_
	exit "$errcode"
}

flatpak_installed() {
	installed flatpak && return "$TRUE" || return "$FALSE"
}

flatpak_enabled() {
	if [[ -f "$apt_dir/$pref_file" ]]; then
		grep -q '^# Package:' "$pref_file" && return "$TRUE" || return "$FALSE"
	else
		return "$TRUE"
	fi
}

enable_flatpak() {
	if [[ ! -f "$apt_dir/$pref_file" ]]; then
		printf "Installation of Flatpak and Flatpak packages is enabled.\n"
	elif grep -q '^Package:' "$apt_dir/$pref_file"; then
		sudo_login 1
		sudo sed -i '/^Package/s/^/# /;/^Pin/s/^/# /' "$apt_dir/$pref_file"
		printf "Installation of Flatpak and Flatpak packages is now enabled.\n"
	fi
	return 0
}

disable_flatpak() {
	local -r script_dir=$(dirname "$(readlink -f "${0}")")
	if [[ ! -f "$apt_dir/$pref_file" ]]; then
		sudo_login 1
		cpvs_base "$script_dir/files/$pref_file" "$apt_dir/"
		printf "%s has been created.\n" "$pref_file"
		printf "Installation of Flatpak and Flatpak packages is now disabled.\n"
	elif grep -q '^# Package:' "$apt_dir/$pref_file"; then
		sudo_login 1
		sudo sed -i '/Package/s/^# //;/Pin/s/^# //' "$apt_dir/$pref_file"
		printf "\nInstallation of Flatpak and Flatpak packages is now disabled.\n"
	else
		printf "\nInstallation of Flatpak and Flatpak packages is already disabled.\n"
	fi
	return 0
}

flatpak_status() {
	if flatpak_installed; then
		printf "Installation of Flatpak and Flatpak packages is "
		flatpak_enabled && printf "enabled.\n" || printf "disabled.\n"
	else
		printf "Flatpak is not installed.\n"
	fi
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="2.0.26329"
	local -i exit_code=0
	local -r apt_dir=/etc/apt/preferences.d
	local -r pref_file=noflatpak.pref
	local -i noOpt=1
	local -r optstr=":dehs"
	local opt OPTARG OPTIND
	while getopts "$optstr" opt; do
		case "$opt" in
			d ) disable_flatpak ;;
			e ) flatpak_installed && enable_flatpak ;;
			h ) help 0 ;;
			s ) flatpak_status ;;
			? ) printf "\n%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help "$E_INVALID_ARG"
		esac
		exit_code="$?"
		noOpt=0
	done
	if (( noOpt == 1 )); then
		printf "%s No argument passed.\n" "$RED_ERROR" >&2
		help "$E_MISSING_ARG"
	fi
	shift "$(( OPTIND - 1 ))"
	over_line "$script $version"
	exit "$exit_code"
}

main "$@"
