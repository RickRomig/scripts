#!/usr/bin/env bash
##########################################################################
# Script Name  : driver-manager.sh
# Description  : Installs the Linu Mint Driver Manager on LMDE 7 (Gigi) & Debian 13 (Trixie)
# Dependencies : gdebi wget
# Arguments    : None
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 05 Nov 2025
# Last updated : 22 Mar 2026
# Comments     : Based on instructions provided by Andrea Borman
#              : YouTube - https://www.youtube.com/watch?v=-Q_U5lLTxmU
#              : I don't know of a way to verify or update packages.
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

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 81
fi

## Global Variables ##

tmp_dir=$(mktemp -qd) || die "Failed to create temporary directory." "$E_TEMP_DIR"

## Functions ##

check_dependencies() {
  local packages=( gdebi wget )
  check_packages "${packages[@]}"
}

check_codename() {
  codename=$(/usr/bin/lsb_release --codename --short)
  case "$codename" in
    trixie|gigi ) return "$TRUE" ;;
    * ) return "$FALSE"
  esac
}

# shellcheck disable=SC2317
# Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
cleanup() {
	[[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
}

install_packages() {
	local idx
  local urls=(
    "http://packages.linuxmint.com/pool/main/m/mint-info"
    "http://packages.linuxmint.com/pool/main/m/mintsystem"
    "http://launchpadlibrarian.net/643489850"
    "http://launchpadlibrarian.net/689619190"
    "http://packages.linuxmint.com/pool/main/m/mintdrivers"
  )
  local packages=(
    "mint-info-cinnamon_2025.11.11_all.deb"
    "mintsystem_8.6.5_all.deb"
    "python3-xkit_0.5.0ubuntu6_all.deb"
    "ubuntu-drivers-common_0.9.7.6_amd64.deb"
    "mintdrivers_1.8.8_all.deb"
  )
  sudo_login 2
  for (( idx=0; idx < "${#urls[@]}"; idx++ )); do
	  printf "Installing %s...\n" "${packages[idx]}"
    wget -q -P "$tmp_dir" "${urls[idx]}/${packages[idx]}"
    sudo gdebi -n "$tmp_dir/${packages[idx]}"
    # sudo dpkg -i "$tmp_dir/${packages[idx]}"; sudo apt-get install --fix-broken
    printf "%s installed.\n" "${packages[idx]}"
  done
  printf "Mint Driver Manager installed.\n"
}

exit_script() {
  local -r script="${0##*/}"
  local -r version="1.4.26081"
  over_line "$script $version"
  exit
}

main() {
  trap cleanup EXIT
  printf "Installs the Linux Mint Driver Manager on LMDE 7 (Gigi) & Debian 13 (Trixie)\n"
  check_codename || { printf "Only Debian 13 and LMDE 7 are supported at this time.\n"; exit_script; }
  check_dependencies
	install_packages
  exit_script
}

## Execution ##

main "$@"
