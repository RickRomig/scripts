#!/usr/bin/env bash
##########################################################################
# Script Name  : no-flatpak.sh
# Description  : Enable/disable Flatpaks in a Debian or Ubuntu-based system.
# Dependencies : None
# Arguments    : [-dehs] (See help function)
# Author       : Copyright (C) 2024, Richard B. Romig, MosfaNet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 02 Mar 2024
# Updated      : 16 Nov 2025
# Comments     :
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

# Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Global Variables ##

readonly script="${0##*/}"
readonly version="1.3.25320"
readonly pref_file="/etc/apt/preferences.d/noflatpak.pref"
script_dir=$(dirname "$(readlink -f "${0}")"); readonly script_dir

## Functions ##

help() {
	local errcode="${1:-2}"
	local updated="16 Nov 2025"
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
	 exists flatpak && return "$TRUE" || return "$FALSE"
}

flatpak_enabled() {
	if [[ -f "$pref_file" ]]; then
		grep -q '^# Package:' "$pref_file" && return "$TRUE" || return "$FALSE"
	else
		return "$TRUE"
	fi
}

enable_flatpak() {
	if [[ -f "$pref_file" ]]; then
		if grep -q '^Package:' "$pref_file"; then
			sudo_login 1
			sudo sed -i '/^Package/s/^/# /;/^Pin/s/^/# /' "$pref_file"
			printf "Installation of Flatpak and Flatpak packages is now enabled.\n"
		else
      printf "Installation of Flatpak and Flatpak packages is already enabled by %s.\n" "$pref_file"
    fi
  else
    printf "%s does not exist.\nInstallation of Flatpak and Flatpak packages is enabled by default.\n" "$pref_file"
  fi
}

disable_flatpak() {
  if [[ -f "$pref_file" ]]; then
    if grep -q '^# Package:' "$pref_file"; then
			sudo_login 1
      sudo sed -i '/Package/s/^# //;/Pin/s/^# //' "$pref_file"
      printf "\nInstallation of Flatpak and Flatpak packages is now disabled.\n"
    else
      printf "\nInstallation of Flatpak and Flatpak packages is already disabled.\n"
    fi
  else
		sudo_login 1
    sudo cp "$script_dir/files/${pref_file##*/}" "${pref_file%/*}/"
    printf "%s has been created. Installation of Flatpak and Flatpak packages is now disabled.\n" "$pref_file"
  fi
}

main() {
  local noOpt opt optstr OPTARG OPTIND
	printf "Flatpack is "
	flatpak_installed && printf "installed.\n" || printf "not installed.\n"
	noOpt=1
	optstr=":dehs"
	while getopts "$optstr" opt; do
		case "$opt" in
			d )
				disable_flatpak
				;;
			e )
				enable_flatpak
				;;
			h )
				help 0
				;;
			s )
				printf "Installation of Flatpak and Flatpak packages is "
				flatpak_enabled && printf "enabled.\n" || printf "disabled.\n"
				;;
			? )
				printf "\n%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help 2
		esac
		noOpt=0
	done
	[[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$RED_ERROR" >&2; help 1; }
	shift "$(( OPTIND - 1 ))"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
