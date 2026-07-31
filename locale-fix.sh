#!/usr/bin/env bash
###############################################################################
# Script Name  : locale-fix.sh
# Description  : Fix for update-initramfs error
# Dependencies : locale-gen, update-initramfs
# Arguments    : none
# Author       : Copyright © 2025 Richard Romig, Luddite Geek
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 01 Jan 2025
# Updated      : 30 Jul 2026
# Version      : 2.7.26211
# Comment      :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

show_intro() {
  local -r script="$1"
  cat << _INTRO_
$script changes the setting to store locales in individual locale direectories
instead of a single archive file.

During some updates the following warning may occur:
  ${lightyellow}Warning: No support for locale: us_US.UTF-8${normal}
The problem is that /usr/share/initramfs-tools/hooks/root_locale is expecting
to see individual locale directories in /usr/lib/locale, but locale-gen is
configured to generate an archive file by default.

Run only if the above warning occurs.

_INTRO_
}

purge_and_update() {
  default_yes "Purge existing locales & save in individual files?" || { printf "No changes made to locale directories.\n"; return 0; }
  printf "\nPurging existing locales and changing the default setting\n"
  printf "to not store compiled locale data in a single archive.\n"
  sudo_login 2
  sudo locale-gen --purge --no-archive
  printf "Updating the existing initramfs...\n"
  sudo update-initramfs -u
  return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="2.7.26211"
  show_intro "$script"
  purge_and_update
  over_line "$script $version"
  exit
}

main "$@"
