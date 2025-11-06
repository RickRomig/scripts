#!/usr/bin/env bash
##########################################################################
# Script Name  : driver-manager.sh
# Description  : Installs Mint Driver Manager on LMDE 7 (Gigi) & Debian 13 (Trixie)
# Dependencies : gdebi wget
# Arguments    : None
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 05 Nov 2025
# Last updated : 05 Nov 2025
# Version      : 1.0.25309
# Comments     : Based on instructions provided by Andrea Borman
#              : YouTube - https://www.youtube.com/watch?v=-Q_U5lLTxmU
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
  exit 1
fi

## Global Variables ##

tmp_dir=$(mktemp -qd) || die "Failed to create temporary directory." 1

## Functions ##

check_dependencies() {
  local packages=( gdebi wget )
  check_packages "${packages[@]}"
}

# shellcheck disable=SC2317
# Don't warn about unreachable commands in this function
# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
cleanup() {
	[[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
}

install_package() {
  local url="$1"
  local pkg="$2"
  printf "Installing %s...\n" "$pkg"
  wget -P "$tmp_dir" "$url/$pkg"
  sudo gdebi -n "$tmp_dir/$pkg"
  printf "%s installed.\n" "$pkg"
}

main() {
  sudo_login 2
  check_dependencies
  local -r script="${0##*/}"
  local -r version="1.0.25309"
  local urls=(
    "http://packages.linuxmint.com/pool/main/m/mint-info"
    "http://packages.linuxmint.com/pool/main/m/mintsystem"
    "http://launchpadlibrarian.net/643489850"
    "http://launchpadlibrarian.net/689619190"
    "http://packages.linuxmint.com/pool/main/m/mintdrivers"
  )
  local pkgs=(
    "mint-info-cinnamon_2025.10.06+lmde_all.deb"
    "mintsystem_8.6.3_all.deb"
    "python3-xkit_0.5.0ubuntu6_all.deb"
    "ubuntu-drivers-common_0.9.7.6_amd64.deb"
    "mintdrivers_1.8.4_all.deb"
  )
  for (( i=0; i <= 4; i++ )); do
    install_package "${urls[i]}" "${pkgs[i]}"
  done
  over_line "$script $version"
  exit
}

## Execution ##

trap cleanup EXIT
main "$@"
