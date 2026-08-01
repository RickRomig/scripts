#!/usr/bin/env bash
###############################################################################
# Script Name  : no-snaps.sh
# Description  : Enable/disable Snaps in Debian/Ubuntu-based systems.
# Dependencies : None
# Arguments    : [-dehs] (See help function)
# Author       : Copyright (C) 2020, Richard B. Romig, MosfaNet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 30 Jun 2020
# Updated      : 01 Aug 2026
# Version      : 4.4.26213
# Comments     : In Linux Mint, snapd package is 'uninstalled'
#              : Script is untested.
#              : See EZNix snapkill at https://github.com/ravik1997/SnapKill
# TODO (Rick)  : Need to enable/disable snapd in systemd?
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
###############################################################################
# This program is free software; you can redistribute it and/or modify  it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
###############################################################################

# shellcheck source=/home/rick/bin/functionlib.bash
source ~/bin/functionlib.bash || { printf "\e[91mERROR:\e[0m Unable to source functionlib.bash\n"; exit 1; }

help() {
  local -r script="$1"
  local -r version="$2"
	local -ri errcode="${3:-2}"
	local -r updated="28 May 2026"
	cat << _HELP_
${green}Usage:${normal} $script [-dehs]
${orange}OPTIONS:${normal}
  -d    Disable the installation of snapd and snap packages.
  -e    Enable the installation of snapd and snap packages.
  -h    Show this help message and exit.
  -s    Status of snapd and snap package installation.
$script v$version, updated $updated
_HELP_
  exit "$errcode"
}

# Is snapd installed?
snapd_installed() {
  installed snapd && return "$TRUE" || return "$FALSE"
}

# Are any snap packages installed?
snap_packages() {
  local -i snapCount
  if snapd_installed; then
    snapCount=$(wc -l < <(snap list))
    (( snapCount > 0 )) && return "$TRUE"
  fi
  return "$FALSE"
}

snaps_enabled() {
	local -r pref_file="$1"
  grep -q 'active' < <(systemctl status snapd 2>/dev/null) && return "$TRUE"
  if [[ -f "$pref_file" ]]; then
    grep -q '^# Package:' "$pref_file" && return "$TRUE"
  fi
  return "$FALSE"
}

enable_snaps() {
  is_systemd || die "SystemD is required for Snaps." 1
	local -r pref_file="$1"
  if [[ ! -f "$pref_file" ]]; then
    printf "%s does not exist. Installation of Snapd and Snap packages is enabled by default.\n" "$pref_file"
    return 0
  fi
  if grep -q '^Package:' "$pref_file"; then
    sudo sed -i '/^Package/s/^/# /;/^Pin/s/^/# /' "$pref_file"
    printf "Installation of Snapd and Snap packages is now enabled.\n"
  else
    printf "Installation of Snapd and Snap packages is already enabled by %s.\n" "$pref_file"
  fi
  return 0
}

disable_snaps() {
	local -r pref_file="$1"
  local -r script_dir=$(dirname "$(readlink -f "${0}")")
  if snap_packages; then
    printf "Snap packages are installed.\nRemove all Snaps before disabling Snaps.\n"
    return 0
  fi
  if [[ ! -f "$pref_file" ]]; then
    sudo_login 1
    sudo cp "$script_dir/files/${pref_file##*/}" "${pref_file%/*}/"
    printf "%s has been created. Installation of Snapd and Snap packages is now disabled.\n" "$pref_file"
    exists snapd && sudo apt=get purge snapd -qq
    return 0
  fi
  if grep -q '^# Package:' "$pref_file"; then
    sudo_login 1
    sudo sed -i '/Package/s/^# //;/Pin/s/^# //' "$pref_file"
    printf "Installation of Snapd and Snap packages is now disabled.\n"
    exists snapd && sudo apt=get purge snapd -qq
  else
    printf "Installation of Snapd and Snap packages is already disabled.\n"
  fi
  return 0
}

main() {
  local -r script="${0##*/}"
  local -r version="4.4.26213"
  local -r pref_file=/etc/apt/preferences.d/nosnap.pref
	local -i exit_code=0
  local opt OPTARG OPTIND
  local -i noOpt=1
  local -r optstr=":dehs"
  printf "Enables or disables the installation of Snapd and Snap packages.\n"
  snapd_installed && printf "Snapd installed\n" || printf "Snapd is not installed.\n"
  while getopts "$optstr" opt; do
    case "$opt" in
      d )
        disable_snaps "$pref_file"
        ;;
      e )
        if snapd_installed && snaps_enabled "$pref_file"; then
          printf "Snaps are already enabled.\n"
        else
          enable_snaps "$pref_file"
        fi
        ;;
      h )
        help 0
        ;;
      s )
        snaps_enabled "$pref_file" && printf "Snaps are enabled.\n" || printf "Snaps are disabled.\n"
        ;;
      ? )
        printf "\n%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
        help "$E_INVALID_ARG"
    esac
    exit_code="$?"
	  noOpt=0
  done
  [[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$RED_ERROR" >&2; help "$E_MISSING_ARG"; }
  shift "$(( OPTIND - 1 ))"
  over_line "$script $version"
  exit "$exit_code"
}

main "$@"
