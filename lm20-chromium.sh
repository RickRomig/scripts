#!/usr/bin/env bash
##########################################################################
# Script Name  : lm20-chromium.sh
# Description  : Installs Chromium from Debian repositories through APT pinning
# Dependencies : none
# Arguments    : none
# Author       : Copyright (C) 2020, Richard B. Romig, 28 Jun 2020
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Comments     : Use only with Linux Mint 20.x or Ubuntu 20.04
#              : Sudo access is required.
#              : Code extacted from instructions at Linux Mint
#              : https://linuxmint-user-guide.readthedocs.io/en/latest/chromium.html
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Functions ##

# Add Debian repositories for Chromium
deb_sources() {
  printf "Creating debian-chromium.list ...\n\n"
  cat << EOT sudo tee /etc/apt/sources.list.d/debian-chromium.list > /dev/null
deb https://deb.debian.org/debian buster main
deb https://deb.debian.org/debian buster-updates main
deb http://security.debian.org/ buster/updates main
EOT
  printf "\nAPT sources updated.\n"
}

# Set preferences so that only Chromium is installed and updated from the Debian repositories.
deb_preferences() {
  printf "Creating debian-chromium.pref ...\n\n"
  cat << EOT sudo tee /etc/apt/preferences.d/debian-chromium.pref > /dev/null
# Don't install anything other than chromium from the Debian repos
Package: *
Pin: origin "deb.debian.org"
Pin-Priority: -10

# Don't install anything other than chromium from the Debian repos
Package: *
Pin: origin "security.debian.org"
Pin-Priority: -10

# Exclude the game chromium-bsu
Package: chromium-bsu*
Pin: origin "deb.debian.org"
Pin-Priority: -10

# Exclude the game chromium-bsu
Package: chromium-bsu*
Pin: origin "security.debian.org"
Pin-Priority: -10

# Pattern includes 'chromium'
Package: chromium*
Pin: origin "deb.debian.org"
Pin-Priority: 700

# Pattern includes 'chromium'
Package: chromium*
Pin: origin "security.debian.org"
Pin-Priority: 700

# Chromium dependencies only in buster
Package: /libevent-2.1-6/ /libicu63/ /libjpeg62-turbo/ /libvpx5/
Pin: origin "deb.debian.org"
Pin-Priority: 1

# Chromium dependencies only in buster
Package: /libevent-2.1-6/ /libicu63/ /libjpeg62-turbo/ /libvpx5/
Pin: origin "security.debian.org"
Pin-Priority: 1
EOT
  printf "\nAPT preferences updated.\n"
}

# Purges the empty chromium-browser package and installs chromium from Debian repos
install_chromium() {
  printf "Installing chromium from the Debian repositories ...\n\n"
  # Pull Debian signing keys from keyserver.ubuntu.com
  sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys DCC9EFBF77E11517
  sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 648ACFD622F3D138
  sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 112695A0E562B32A
  sudo apt-get update
  sudo apt-get remove --purge chromium-browser
  sudo apt-get install chromium
  printf "\nChromium installed from the Debian repositories.\n"
}

# Check if running Linux Mint 20.x or Ubuntu 20.04
valid_version() {
  ver_code=$(awk -F= '/VERSION_CODENAME/ {print $NF}' /etc/os-release)
  case "$ver_code" in
    ulyana|ulyssa|uma|una|focal )
      return "$TRUE" ;;
    * )
      return "$FALSE" ;;
  esac
}

main() {
  local _script; _script=$(basename "$0")
  local _version="0.3.2"
  local _updated="11 Apr 2023"

  user_in_sudo

  clear
  box "$_script v$_version ($_updated)"
  printf "Installs Chromium on Linux Mint 20.x from Debian 10 repositories\n"
  printf "instead of installing Snapd and using the Ubuntu Snap Store.\n"
  deb_sources
  deb_preferences
  install_chromium
  exit
}

## Execution ##

if valid_version; then
  main
else
  die "Script is only for use with Linux Mint 20.x or Ubuntu 20.04." 1
fi
