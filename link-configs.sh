#!/usr/bin/env bash
##########################################################################
# Script Name  : link-configs.sh
# Description  : Create symbolic links for configuration files.
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 09 Aug 2025
# Last updated : 02 Oct 2025
# Comments     : To be used on existing installations
# TODO (Rick)  :
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
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

## Global Variables ##

readonly script="${0##*/}"
readonly version="2.4.25275"
readonly old_configs="$HOME"/old-configs

## Functions ##

help() {
	local errcode="${1:-2}"
	local -r updated="02 Oct 2025"
	cat << _HELP_
${orange}$script${normal} $version, Upated: $updated
Create symbolic links from configs and scripts repos.

${green}Usage:${normal} $script [-cdhst]
${orange}Available options:${normal}
	-c	Symlink configuration files to ~/.config
	-d	Symlink dot files to ~/
	-h	Show this help message and exit
	-s	Symlink scripts to ~/bin
	-t	Apply tweaks to /etc/sudoers.d and /etc/sysctl.conf
_HELP_
  exit "$errcode"
}

# Create symbolic links to dotfiles in the home directory
link_dot_files() {
	local dot_file dot_files repo_dir
	[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
	repo_dir=$(assign_cfg_repo)
	dot_files=(
		.bash_aliases
		.bashrc
		.bash_logout
		.face
		.imwheelrc
		.inputrc
		.profile
	)
	[[ -f "$HOME/.curlrc" ]] && rm .curlrc
	[[ -f "$HOME/.wgetrc" ]] && rm .wgetrc
	printf "\e[93mLinking dotfiles ...\e[0m\n"
	for dot_file in "${dot_files[@]}"; do
		printf "\e[93mLinking %s ...\e[0m\n" "$dot_file"
		[[ -f "$HOME/$dot_file" ]] && mv -v "$HOME/$dot_file" "$old_configs/"
		ln -sv "$repo_dir/$dot_file" "$HOME/$dot_file"
	done
}

# Link configuration files to directories in ~/.config
link_config_files() {
	local cfg_file cfg_files repo_dir
	[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
	repo_dir=$(assign_cfg_repo)
	cfg_files=(
		"bat/config"
		"dunst/dunstrc"
		"fastfetch/config.jsonc"
		"flameshot/flameshot.ini"
		"glow/glow.yml"
		"kitty/bindings.list"
		"kitty/kitty.conf"
		"marktext/preferences.json"
		"micro/bindings.json"
		"micro/settings.json"
		"picom/picom.conf"
		"rofi/arc_dark_colors.rasi"
		"rofi/arc_dark_transparent_colors.rasi"
		"rofi/config.rasi"
		"redshift.conf"
		"terminator/config"
		"VSCodium/User/settings.json"
	)
	for cfg_file in "${cfg_files[@]}"; do
		if [[ -f "$HOME/.config/$cfg_file" ]]; then
			printf "\e[93mLinking %s to %s ...\e[0m\n" "$repo_dir/$cfg_file" "$HOME/.config"
			if [[ "$cfg_file" == "redshift.conf" ]]; then
				mv -v "$HOME/.config/$cfg_file" "$old_configs/"
			else
				[[ -d "$old_configs/${cfg_file%/*}" ]] || mkdir -p "$old_configs/${cfg_file%/*}"
				mv -v "$HOME/.config/$cfg_file" "$old_configs/${cfg_file%/*}/${cfg_file##*/}"
			fi
			ln -sv "$repo_dir/$cfg_file" "$HOME/.config/$cfg_file"
		else
			printf "%s/%s not present.\n" "$HOME/.config" "$cfg_file"
		fi
	done
	[[ -d "$HOME/.config/micro/plug/bookmark" ]] || micro -plugin install bookmark
}

set_reserved_space() {
	local home_part root_part
	root_part=$(df -P | awk '$NF == "/" {print $1}')
	home_part=$(df -P | awk '$NF == "/home" {print $1}')
	printf "e[93mSetting reserved space on root & home partitions...\e[0m\n"
	sudo tune2fs -m 2 "$root_part"
	[[ "$home_part" ]] && sudo tune2fs -m 0 "$home_part"
	printf "Drive reserve space set.\n"
}

check_swappiness() {
	if [[ -f /etc/sysctl.conf ]]; then
		grep 'vm.swappiness' /etc/sysctl.conf && return "$TRUE"
	fi
	[[ -f /etc/sysctl.d/90-swappiness.conf ]] && return "$TRUE"
	return "$FALSE"
}

# Add tweaks to /etc/sudoers.d directory and set swappiness
set_system_tweaks() {
	printf "\e[93mApplying password feeback...\e[0m\n"
	if [[ -f /etc/sudoers.d/0pwfeedback ]]; then
		printf "Sudo password feedback is already enabled with 0pwfeedback\n"
	else
		sudo cp -v "$repo_dir"/sudoers/0pwfeedback /etc/sudoers.d/
		sudo chmod 440 /etc/sudoers.d/0pwfeedback
	fi
	if [[ -f /etc/sudoers.d/10timeout ]]; then
		printf "Sudo timeout has already been set.\n"
	else
		printf "\e[93mApplying sudo timeout...\e[0m\n"
		sudo cp -v ~/Downloads/configs/sudoers/10timeout /etc/sudoers.d/
		sudo chmod 440 /etc/sudoers.d/10timeout
	fi
	if [[ -f /etc/apt/preferences.d/nosnap.pref ]]; then
		printf "Snap packages have already been disabled.\n"
	else
		printf "Disabling installation of Snapd and Snap packages...\n"
		sudo cp -v ~/Downloads/configs/apt/nosnap.pref /etc/apt/preferences.d/
	fi
	check_swappiness && sudo cp -v ~/Downloads/configs/90-swappiness.conf /etc/sysctl.d/
	set_reserved_space
}

link_script_dir() {
	if [[ -L "$HOME/bin" ]]; then
		printf "Script directory is already linked to cloned repository.\n"
	else
		printf "\e[93mLinking scripts repo to ~/bin...\e[0m\n"
		[[ -d "$HOME/bin" ]] && rm -rf "${HOME:?}/bin"
		ln -sv ~/Downloads/scripts/ "$HOME/bin"
	fi
}

check_for_gitea() {
	[[ -d "$HOME/gitea" ]] && return "$TRUE" || return "$FALSE"
}

main() {
	local noOpt opt optstr OPTIND OPTARG
	noOpt=1
	optstr=":cdhst"
	while getopts "$optstr" opt; do
		case "$opt" in
			c )
				check_for_gitea || link_config_files ;;
			d )
				check_for_gitea || link_dot_files ;;
			h )
				help 0 ;;
			s )
				check_for_gitea || link_script_dir ;;
			t )
				check_for_gitea || set_system_tweaks ;;
			? )
				printf "%s Invalid option -%s\n" "$RED_ERROR" "$OPTARG" >&2
				help 2
		esac
		noOpt=0
	done
	[[ "$noOpt" = 1 ]] && { printf "%s No argument passed.\n" "$RED_ERROR" >&2; help 1; }
	shift "$(( OPTIND - 1 ))"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
