#!/usr/bin/env bash
#####################################################################
# Script Name  : mint-desktip.sh
# Description  : Mint 18.x installer for desktops
# Dependencies : apt-get, wget, gdebi, curl
# Args         : None
# Author       : Richard Romig
# Email        : rick.romig@gmail.com
# Comment      : Based on a script by Joe Collins at EzeeLinux.com
#              : Developmental script, do not us for production.
# TODO (rick)  : Needs to be completely rewritten for HP6005 share.
# License      : GNU General Public License, version 2.0
###############################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  echo -e "\e[91mERROR:\e[0m functionlib not found!" >&2
  exit 1
fi

# Variables

readonly _script=$(basename "$0")
readonly _version="2.0.12"
readonly _updated="21 Jun 2021"

readonly my_user=$USER
readonly home_dir=$HOME
readonly start_dir=$PWD

# Execution

if [[ "$start_dir" != "$home_dir" ]]; then
  pushd "$home_dir" || die "pushd failed"
fi

echo "$_script v$_version ($_updated)"
echo "Installs basic software for Linux Mint Desktops."

# Basic system utilities

sudo apt update -qq

# Install gdebi and grsyncif not already installed
check_package gdebi
check_package grsync

# Install other utility programs
sudo apt install -yyq htop conky terminator clamav dtrx exfat-fuse exfat-utils
sudo apt install -yyq openssh-server silversearcher-ag traceroute

# Install Virtualbox from repositories
# sudo apt install -yyq virtualbox virtualbox-guest=additions-iso virtualbox-ext-pack
# sudo adduser "$my_user" vboxusers

# Install audio applications
sudo apt install -yyq asunder audacity easytag flac lame

# Install VLC if not already installed
check_package vlc

# Install guvcview if a camera device exists
if ls /dev/video* > /dev/null 2>&1; then
  sudo apt install -yyq guvcview
else
  echo "No web cam available"
fi

# Miscellaneous applications
sudo apt install -yyq password-gorilla bluefish dropbox msttcorefonts

# Install games
sudo apt install -yyq aisleriot tali

# Bat, Google Chrome
pushd "$home_dir/Downloads/" || die "pushd failed"
wget https://dl.google.com/Linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb
popd || die "popd failed"

# multisystem from ppa
sudo apt-add-repository -y "deb http://liveusb.info/multisystem/depot all main"
wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | sudo apt-key add - 2>/dev/null #apt-key deprecated
sudo apt update -qq
sudo apt install -yyq multisystem
# Atom Editor
curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add - 2>/dev/null #apt-key deprecated
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
# sudo apt update
sudo apt install -yyq atom

# other actions

# disable hibernation by moving file to root folder
sudo mv -v /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla /

# Remove mono and orca
sudo apt remove mono-runtime-common gnome-orca -yy
sudo apt install -yy xpad

# fix for update-initramfs
sudo locale-gen --purge --no-archive
sudo update-initramfs -u -t

# add directories if they don't already exist

[[ -d "$home_dir/bin" ]] || mkdir -p "$home_dir/bin"
[[ -d "$home_dir/homepage" ]] || mkdir -p "$home_dir/homepage"
[[ -d "$home_dir/.ssh" ]] || mkdir -p "$home_dir/.ssh"
if [[ ! -d "$home_dir/Work" ]]; then
  mkdir "$home_dir/Work"
  pushd "$home_dir/Desktop" || die "pushd failed"
  ln -s "/home/$my_user/Work" Work
  ln -s "/home/$my_user/bin" bin
  popd || die "popd failed"
fi

if [[ "$start_dir" != "$home_dir" ]]; then
  popd || die "popd failed"
fi

# installation done

echo "All done! Please reboot the computer."

exit
