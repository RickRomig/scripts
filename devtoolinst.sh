#!/usr/bin/env bash
#####################################################################
# Script Name  : devtoolinst.sh
# Description  : Installs C development tools if not installed
# Dependencies : none
# Arguments    : none
# Author       : Copyright (C), Richard Romig
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 01 Jan 2017
# Updated      : 21 May 2026
# Comment      :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
#####################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#####################################################################

## Source function library ##

# shellcheck source=/home/rick/bin/functionlib
source ~/bin/functionlib || { printf "\e[91mERROR:\e[0m Unable to source functionlib\n"; exit 1; }

## Functions ##

install_tools() {
  local package packages
  packages=( binutils build-essential gcc libc6 )
  printf "Checking and installing C devlopment tools...\n"
	for package in "${packages[@]}"; do
		if installed "$package"; then
			printf "%s installed.\n" "$package"
		else
			printf "Installing %s...\n" "$package"
      sudo apt-get install -y "$package"
		fi
	done
}

main() {
	local -r script="${0##*/}"
	local -r version="2.3.26141"
  install_tools
	over_line "$script $version"
  exit
}

## Execution ##

main "$@"
