#!/usr/bin/env bash
#########################################################################
# Script Name  : locale-fix.sh
# Description  : Fix for update-initramfs error
# Dependencies : locale-gen, update-initramfs
# Arguments    : none
# Author       : Copyright © 2025 Richard Romig, Luddite Geek
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : unknown
# Updated      : 19 Jul 2025
# Comment      :
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

set -eu

## Global Variables ##

readonly script="${0##*/}"
readonly version="2.5.25200"

## Functions ##

show_intro() {
  local updated="19 Jul 2025"
  cat << _INTRO_
$script changes the setting to store locales in individual locale direectories
instead of a single archive file.

During some updates the following warning may occur:
  Warning: No support for locale: us_US.UTF-8
The problem is that /usr/share/initramfs-tools/hooks/root_locale is expecting
to see individual locale directories in /usr/lib/locale, but locale-gen is
configured to generate an archive file by default.

Version: $version, last updated on $updated.
_INTRO_
}

purge_update() {
  printf "\nPurging existing locales and changing the default setting\n"
  printf "to not store compiled locale data in a single archive.\n"
  sudo locale-gen --purge --no-archive
  printf "Updating the existing initramfs.\n"
  sudo update-initramfs -u # -t (-t flag isn't listed in man page)
}

main() {
  sudo_login 2
  show_intro
  purge_update
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
