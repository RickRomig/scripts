#!/usr/bin/env bash
#########################################################################
# Script Name  : locale-fix.sh
# Description  : Fix for update-initramfs error
# Dependencies : locale-gen, update-initramfs
# Arguments    : none
# Author       : Richard Romig
# Email        : rick.romig@gmail.com
# Comment      :
# License      : GNU General Public License, version 2.0
#########################################################################

## Variables ##

readonly _script=$(basename "$0")
readonly _version="0.2.2"
readonly _updated="23 Sep 2022"

## Functions ##

show_intro() {
  cat << EOF
$_script changes setting to store locales in individual locale direectories
instead of a single archive file.

During some updates the following warning may occur:
  Warning: No support for locale: us_US.UTF-8
The problem is that /usr/share/initramfs-tools/hooks/root_locale is expecting
to see individual locale directories in /usr/lib/locale, but locale-gen is
configured to generate an archive file by default.

Version: $_version, last updated on $_updated.
EOF
}

## Execution ##

user_in_sudo

show_intro

# Remove existing locales & do not store compiled locale data in a single archive
printf "\nPurging existing locales and changing default setting to not store\n"
printf "compiled locale data in a single archive.\n"
sudo locale-gen --purge --no-archive

printf "Updating the existing initramfs.\n"
sudo update-initramfs -u -t
exit
