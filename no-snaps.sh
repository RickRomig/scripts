#!/usr/bin/env bash
###############################################################################
# Script Name  : no-snaps.sh
# Description  : Enable/disable Snaps in Debian/Ubuntu-based systems.
# Dependencies : None
# Arguments    : [-dehs] (See help function)
# Author       : Copyright (C) 2020, Richard B. Romig, MosfaNet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 30 Jun 2020
# Updated      : 25 Nov 2026
# Version      : 5.0.26329
# Comments     : In Linux Mint, snapd package is 'uninstalled'
#              : Script is untested.
#              : See EZNix snapkill at https://github.com/ravik1997/SnapKill
# TODO (Rick)  : Need to enable/disable snapd in systemd?
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
	${green}Usage:${normal} $script [-dehs]
	${orange}OPTIONS:${normal}
	-d    Disable the installation of snapd and snap packages.
	-e    Enable the installation of snapd and snap packages.
	-h    Show this help message and exit.
	-s    Status of snapd and snap package installation.
	$script v$version, updated $updated
	_HELP_
	exit "$errcode"
}

# Is snapd installed?
snapd_installed() {
	installed snapd && return "$TRUE" || return "$FALSE"
}

# Are any snap packages installed?
snap_packages() {
	local -i snapCount
	if snapd_installed; then
		snapCount=$(wc -l < <(snap list))
		(( snapCount > 0 )) && return "$TRUE"
	fi
	return "$FALSE"
}

snaps_enabled() {
	if grep -q 'active' < <(systemctl status snapd 2>/dev/null); then
		return "$TRUE"
	elif [[ -f "$apt_dir/$pref_file" ]]; then
		grep -q '^# Package:' "$apt_dir/$pref_file" && return "$TRUE"
	else
		return "$FALSE"
	fi
}

enable_snaps() {
	is_systemd || die "SystemD is required for Snaps." "$E_UNSUPPORTED"
	if [[ ! -f "$apt_dir/$pref_file" ]]; then
		printf "Installation of Snapd and Snap packages is enabled by default.\n"
	elif grep -q '^Package:' "$apt_dir/$pref_file"; then
		sudo sed -i '/^Package/s/^/# /;/^Pin/s/^/# /' "$apt_dir/$pref_file"
		printf "Installation of Snapd and Snap packages is now enabled.\n"
	fi
	return 0
}

disable_snaps() {
	local -r script_dir=$(dirname "$(readlink -f "${0}")")
	if snap_packages; then
		printf "Snap packages are installed.\n" >&2
		printf "Remove all Snaps before disabling Snaps.\n" >&2
		return 0
	fi
	if [[ ! -f "$apt_dir/$pref_file" ]]; then
		sudo_login 1
		cpvs_base "$script_dir/files/$pref_file}" "$apt_dir/"
		printf "%s has been created. Installation of Snapd and Snap packages is now disabled.\n" "$pref_file"
	elif grep -q '^# Package:' "$apt_dir/$pref_file"; then
		sudo_login 1
		sudo sed -i '/Package/s/^# //;/Pin/s/^# //' "$apt_dir/$pref_file"
		printf "Installation of Snapd and Snap packages is now disabled.\n"
	else
		printf "Installation of Snapd and Snap packages is already disabled.\n"
	fi
	return 0
}

snap_status() {
	if snapd_installed; then
		printf "Installation of Snap packages is "
		snaps_enabled && printf "enabled.\n" || printf "disabled.\n"
	else
		printf "SnapD is not installed.\n"
		printf "Installation of Snapd and Snap packages is disabled.\n"
	fi
	return 0
}

main() {
	local -r script="${0##*/}"
	local -r version="5.0.26329"
	local -r apt_dir=/etc/apt/preferences.d
	local -r pref_file=nosnap.pref
	local -i exit_code=0
	local -i noOpt=1
	local -r optstr=":dehs"
	local opt OPTARG OPTIND
	printf "Enables or disables the installation of Snapd and Snap packages.\n"
	while getopts "$optstr" opt; do
		case "$opt" in
			d ) disable_snaps ;;
			e ) if snapd_installed && snaps_enabled; then
					printf "Snaps are already enabled.\n"
				elif snapd_installed; then
					enable_snaps
				else
					printf "Snapd is not installed.\n" >&2
				fi ;;
			h ) help 0 ;;
			s ) snap_status ;;
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
