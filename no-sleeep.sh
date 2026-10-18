#!/usr/bin/env bash
###############################################################################
# Script Name  : no-sleep.sh
# Description  : Script to disable sleep and hiberation on Debian-based systems
# Dependencies : systemd
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 18 Jul 2023
# Updated      : 18 Oct 2026
# Version      : 3.0.26291
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

set_nosleep() {
	local -r repository=~/Downloads/configs
	[[ -d ~/gitea/configs ]] && repository=~/gitea/configs
	if [[ ! -d "$repository" ]]; then
		printf "%s Local repository not found. Cannot continue.\n" "$RED_ERROR" >&2
		return "$E_FILENOTFOUND"
	fi
	sudo_login 2
	[[ -d /etc/systemd/sleep.conf.d ]] || sudo mkdir -p /etc/systemd/sleep.conf.d
	printf "Copying 99-sleep.conf to /etc/systemd/sleep.conf.d...\n"
	awk -F"/" '{print "==> " $NF}' < <(sudo cp -v "$repository/99-sleep.conf" /etc/systemd/sleep.conf.d/) | sed "s/'$//"
	return "$?"
}

main() {
	local -r script="${0##*/}"
	local -r version="3.0.26291"
	local -i exit_code=0
	is_systemd || die "SystemD is required for this script!" "$E_UNSUPPORTED"
	printf "Disables sleep and hiberation on Debian-based systems.\n"
	set_nosleep
	exit_code="$?"
	over_line "$script $version"
	exit "$exit_code"
}

main "$@"
