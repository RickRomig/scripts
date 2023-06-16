#!/usr/bin/env bash
##########################################################################
# Script Name  : purge-image-rc.sh
# Description  : Purges config files from removed kernels in the 'rc' state
# Dependencies : None
# Arguments    : None
# Author       : Richard B. Romig, 27 Sep 2020
# Email        : rick.romig@gmail.com
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091,SC2034

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Variables ##

_script=$(basename "$0"); readonly _script
readonly _version="0.3.0"
readonly _updated="15 Jun 2023"

## Execution ##

clear
echo "$_script v$_version ($_updated)"
# dpkg --list | egrep -i --color 'linux-image|linux-headers'
echo "Packages in the 'rc' state:"
# rc_img=$(dpkg --list | grep -i linux-image | grep ^rc | awk '{print $2}')
rc_img=$(dpkg --list | awk '/linux-image/ && /^rc/ {print $2}')
echo "$rc_img"
echo "These packages are in the remove/deinstall state with only the config files."
if yes_or_no "Are you sure you want to purge the config files for these images?"; then
  rcpkgs=$(dpkg -l | awk '/^rc/ {print $2}' | wc -l)
  if [[ "$rcpkgs" -gt 0 ]]; then
    printf "%sPurging obsolete linux kernel configuration files...%s\n" "$green" "$normal"
    for i in $(dpkg -l | grep "^rc" | awk '{print $2}'); do sudo apt remove --purge "$i" -yy; done
  fi
  dpkg --list | grep -Ei --color 'linux-image|linux-headers'
else
  leave "No action taken. No packages were purged."
fi
exit
