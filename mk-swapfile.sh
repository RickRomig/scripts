#!/usr/bin/env bash
##########################################################################
# Script Name  : mk-swapfile.sh
# Description  : creates a swap file (/swapfile) in root directory
# Dependencies : none
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 27 Jan 2025
# Last updated : 27 Jan 2025
# Comments     : creates swap file if no other swap exists.
#              : Disable old swap and comment out in /etc/fstab
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

set -eu

## Functions ##

append_fstab() {
	echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
}

swap_exists() {
  local myswap
  myswap=$(awk '/file/ || /partition/ {print $1}' /proc/swaps)
  [[ "$myswap" ]] && return "$TRUE" || return "$FALSE"
}

create_swapfile() {
	printf "Creating swap file in the root directory...\n"
	# create a 1GB swap file (multiple count by number of gigabyes needed)
	sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576	# 4 x count = 4194304
	ls -lh /swapfile  # see the file in the root directory
	sudo mkswap /swapfile # prepare swap file
	sudo chmod 600 /swapfile  # set permissions
	sudo swapon /swapfile # activate the swap file
	append_fstab
}

main() {
	local script version
	script=$(basename "$0")
	version="1.0.25027"
	sudo_login 2
	if swap_exists; then
		printf "A swap device exists and is enabled.\n"
	else
		create_swapfile
	fi
	sudo swapon --show
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
