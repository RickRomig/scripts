#!/usr/bin/env bash
##########################################################################
# Script Name  : lm20-chromium.sh
# Description  : Installs Chromium from Debian repositories through APT pinning
# Dependencies : none
# Arguments    : none
# Author       : Richard B. Romig, 28 Jun 2020
# Email        : rick.romig@gmail.com
# Comments     : Use only with Linux Mint 20 or Ubuntu 20.04
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
  echo -e "Creating debian-chromium.list ...\n"
  cat << EOT sudo tee /etc/apt/sources.list.d/debian-chromium.list
deb https://deb.debian.org/debian buster main
deb https://deb.debian.org/debian buster-updates main
deb http://security.debian.org/ buster/updates main
EOT
  echo $'\n'$"APT sources updated."
}

# Set preferences so that only Chromium is installed and
# updated from the Debian repositories.
deb_preferences() {
  echo -e "Creating debian-chromium.pref ...\n"
  cat << EOT sudo tee /etc/apt/preferences.d/debian-chromium.pref
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
  echo $'\n'$"APT preferences updated."
}

# Purges the empty chromium-browser package and installs chromium from Debian repos
install_chromium() {
  echo -e "Installing chromium from the Debian repositories ...\n"
  # Pull Debian signing keys from keyserver.ubuntu.com
  sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys DCC9EFBF77E11517
  sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 648ACFD622F3D138
  sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 112695A0E562B32A
  sudo apt-get update
  sudo apt-get remove --purge chromium-browser
  sudo apt-get install chromium
  echo $'\n'$"Chromium installed from the Debian repositories."
}

# Check if running Linux Mint 20 or Ubuntu 20.04
is_lm20() {
  ver_code=$(awk -F= '/VERSION_CODENAME/ {print $NF}' /etc/os-release)
  case "$ver_code" in
    ulyana|focal ) return "$TRUE" ;;
    * ) return "$FALSE" ;;
  esac
}

main() {
  _script=$(basename "$0"); local _script
  local _version="0.2.9"
  local _updated="07 Jul 2022"

  user_in_sudo

  clear
  box "$_script v$_version ($_updated)"
  echo "Installs Chromium on Linux Mint 20 from Debian 10 repositories"
  echo "instead of installing Snapd and using the Ubuntu Snap Store."
  deb_sources
  deb_preferences
  install_chromium
  exit
}

## Execution ##

if is_lm20; then
  main
else
  die "Script is only for use with Linux Mint 20 or Ubuntu 20.04."
fi
