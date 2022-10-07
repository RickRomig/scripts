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

readonly _script=$(basename "$0")
readonly _version="0.2.1"
readonly _updated="26 Mar 2022"

## Execution ##

clear
echo "$_script v$_version ($_updated)"
# dpkg --list | egrep -i --color 'linux-image|linux-headers'
echo "Packages in the 'rc' state:"
# rc_img=$(dpkg --list | grep -i linux-image | grep ^rc | awk '{print $2}')
rc_img=$(dpkg --list | awk '/linux-image/ && /^rc/ {print $2}')
echo "$rc_img"
echo "These packages are in the remove/deinstall state with only the config files."
PS3="Are you sure you want to purge the config files for these images? "
select opt in "Yes" "No"
do
  case $REPLY in
    1 )
      sudo apt-get --purge remove "$rc_img"
      echo "Linux headers and image packages:"
      dpkg --list | grep -Ei --color 'linux-image|linux-headers'
      break ;;
    2 )
      leave "No action taken. No packages were purged." ;;
    * )
      echo "${lightred}Invalid option!${normal} 1 = Yes 2 = No" ;;
  esac
done
exit
