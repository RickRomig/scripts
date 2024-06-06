#!/usr/bin/env bash
#########################################################################
# Script Name  : locale-fix.sh
# Description  : Fix for update-initramfs error
# Dependencies : locale-gen, update-initramfs
# Arguments    : none
# Author       : Richard Romig
# Email        : rick.romig@gmail.com
# Created      :
# Updated      : 06 Jun 2024
# Comment      :
# License      : GNU General Public License, version 2.0
#########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  echo -e "\e[91mERROR:\e[0m functionlib not found!" >&2
  exit 1
fi

## Variables ##

_script=$(basename "$0"); readonly _script
readonly _version="2.3.24158"
readonly _updated="06 Jun 2024"

## Functions ##

show_intro() {
  cat << ENDINTRO
$_script changes the setting to store locales in individual locale direectories
instead of a single archive file.

During some updates the following warning may occur:
  Warning: No support for locale: us_US.UTF-8
The problem is that /usr/share/initramfs-tools/hooks/root_locale is expecting
to see individual locale directories in /usr/lib/locale, but locale-gen is
configured to generate an archive file by default.

Version: $_version, last updated on $_updated.
ENDINTRO
}

purge_update() {
  printf "\nPurging existing locales and changing default setting to not\n"
  printf "store compiled locale data in a single archive.\n"
  sudo locale-gen --purge --no-archive
  printf "Updating the existing initramfs.\n"
  sudo update-initramfs -u # -t (-t flag isn't listed in man page)
}

## Execution ##

sudo_login 2
show_intro
purge_update
exit
