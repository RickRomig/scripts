#!/usr/bin/env bash
###############################################################################
# Script Name  : no-flatpak.sh
# Description  : Enable/disable Flatpaks in a Debian or Ubuntu-based system.
# Dependencies : None
# Arguments    : [-dehs] (See help function)
# Author       : Copyright (C) 2024, Richard B. Romig, MosfaNet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 02 Mar 2024
# Updated      : 01 Aug 2026
# Version      : 1.6.26213
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

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

help() {
	local -r script="$1"
	local -r version="$2"
	local -ri errcode="${3:-1}"
	local -r updated="28 May 2026"
	cat << _HELP_
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
	local -r pref_file="$1"
	if [[ -f "$pref_file" ]]; then
		grep -q '^# Package:' "$pref_file" && return "$TRUE" || return "$FALSE"
	else
		return "$TRUE"
	fi
}

enable_flatpak() {
	local -r pref_file="$1"
	if [[ ! -f "$pref_file" ]]; then
    printf "%s does not exist.\nInstallation of Flatpak and Flatpak packages is enabled by default.\n" "$pref_file"
		return 0
  fi
	if grep -q '^Package:' "$pref_file"; then
		sudo_login 1
		sudo sed -i '/^Package/s/^/# /;/^Pin/s/^/# /' "$pref_file"
		printf "Installation of Flatpak and Flatpak packages is now enabled.\n"
	else
    printf "Installation of Flatpak and Flatpak packages is already enabled by %s.\n" "$pref_file"
  fi
	return 0
}

disable_flatpak() {
	local -r pref_file="$1"
	local -r script_dir=$(dirname "$(readlink -f "${0}")")
  if [[ ! -f "$pref_file" ]]; then
		sudo_login 1
    sudo cp "$script_dir/files/${pref_file##*/}" "${pref_file%/*}/"
    printf "%s has been created. Installation of Flatpak and Flatpak packages is now disabled.\n" "$pref_file"
		return 0
  fi
  if grep -q '^# Package:' "$pref_file"; then
		sudo_login 1
    sudo sed -i '/Package/s/^# //;/Pin/s/^# //' "$pref_file"
    printf "\nInstallation of Flatpak and Flatpak packages is now disabled.\n"
  else
    printf "\nInstallation of Flatpak and Flatpak packages is already disabled.\n"
  fi
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="1.6.26213"
	local -i exit_code=0
	local -r pref_file=/etc/apt/preferences.d/noflatpak.pref
  local opt OPTARG OPTIND
	local -i noOpt=1
	local -r optstr=":dehs"
	printf "Flatpack is "
	flatpak_installed && printf "installed.\n" || printf "not installed.\n"
	while getopts "$optstr" opt; do
		case "$opt" in
			d )
				disable_flatpak "$pref_file"
				;;
			e )
				enable_flatpak "$pref_file"
				;;
			h )
				help "$script" "$version" 0
				;;
			s )
				printf "Installation of Flatpak and Flatpak packages is "
				flatpak_enabled "$pref_file" && printf "enabled.\n" || printf "disabled.\n"
				;;
			? )
				printf "\n%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help "$script" "$version" "$E_INVALID_ARG"
		esac
		exit_code="$?"
		noOpt=0
	done
	[[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$RED_ERROR" >&2; help "$script" "$version" "$E_MISSING_ARG"; }
	shift "$(( OPTIND - 1 ))"
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
