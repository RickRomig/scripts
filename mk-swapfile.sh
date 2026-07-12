#!/usr/bin/env bash
##########################################################################
# Script Name  : mk-swapfile.sh
# Description  : creates /swapfile using dd or fallocate
# Dependencies : dd fallocate
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 27 Jan 2025
# Updated      : 12 Jul 2026
# Comments     : creates a swap file if no other swap exists.
#              : Disable old swap and comment out in /etc/fstab
#              : User is prompted to provide size of swap file in GB (integer value)
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

swap_exists() {
  local myswap
  myswap=$(awk '/file/ || /partition/ {print $1}' /proc/swaps)
  [[ "$myswap" ]] && return "$TRUE" || return "$FALSE"
}

create_swapfile() {
	local _opt options size
	options=("Create swap file with dd" "Create swap file with fallocate" "Quit without creating a swap file")
	read -rp "Enter size of swap file in GB: " size
	PS3="Choose creation method: "
	select _opt in "${options[@]}"; do
		case "$REPLY" in
			1 ) dd_swapfile "$size"; break ;;
			2 ) fallocate_swapfile "$size"; break ;;
			3 ) printf "Swap file creation canceled.\n"; break ;;
			* ) printf "%sInvalid choice. Try again.%s\n" "$orange" "$normal" >&2
		esac
	done
	return "$?"
}

dd_swapfile() {
	local size=$(($1 * 1048576))
	printf "Creating swap file in the root directory...\n"
	sudo_login 2
	sudo dd if=/dev/zero of=/swapfile bs=1024 count="$size"
	process_swapfile
	return "$?"
}

fallocate_swapfile() {
	local size="$1"
	printf "Creating swap file in the root directory...\n"
	sudo_login 2
	sudo fallocate -l "$size"G /swapfile
	process_swapfile
	return "$?"
}

process_swapfile() {
	ls -lh /swapfile  				# see the file in the root directory
	sudo e4defrag /swapfile		# defrag swapfile so it's 1 contigous file
	sudo chmod 600 /swapfile	# set file permissions
	sudo mkswap /swapfile			# set up swap area
	sudo swapon /swapfile			# enable swap file
	sudo tee -a /etc/fstab <<< "/swapfile none swap sw 0 0"	# add swapfile to /etc/fstab
	sudo systemctl daemon-reload	# reload daemons
	sudo findmnt --verify			# verity fstab
	return "$?"
}

main() {
	local script="${0##*/}"
	local version="2.2.26174"
	local -i exit_code=0
	if swap_exists; then
		printf "A swap file or partition already exists and is enabled.\n"
		printf "Disable current swap before creating swap file.\n"
	else
		create_swapfile
		exit_code="$?"
	fi
	sudo_login 2
	printf "Current Swap:\n"
	sudo swapon --show
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
