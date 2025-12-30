#!/usr/bin/env bash
##########################################################################
# Script Name  : tweaks.sh
# Description  : Create symbolic links for configuration files.
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 09 Aug 2025
# Last updated : 05 Dec 2025
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
readonly version="4.0.25339"

## Functions ##

help() {
	local errcode="${1:-2}"
	local -r updated="05 Dec 2025"
	cat << _HELP_
${orange}$script${normal} $version, Upated: $updated
Create symbolic links from configs and scripts repos and add tweaks to system settings.

${green}Usage:${normal} $script [-cdhst]
${orange}Available options:${normal}
	-c	Symlink configuration files to ~/.config
	-d	Symlink dot files to ~/
	-h	Show this help message and exit
	-n	Disable snap packages
	-p	Diable sleep, hibrnation, suspend
	-r	Adjust Reserve Space on partitions
	-s	Symlink scripts to ~/bin
	-t	Apply tweaks to /etc/sudoers.d and /etc/sysctl.conf
	-w	Set swappiness
_HELP_
  exit "$errcode"
}

# Create symbolic links to dotfiles in the home directory
link_dot_files() {
	local dot_file dot_files old_configs
	old_configs="$1"
	[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
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
		[[ -d ~/gitea/configs ]] && ln -sv ~/gitea/configs/"$dot_file" ~/"$dot_file"
		[[ -d ~/Downloads/configs ]] && ln -sv ~/Downloads/configs/"$dot_file" ~/"$dot_file"
	done
}

# Link configuration files to directories in ~/.config
link_config_files() {
	local cfg_file cfg_files old_configs
	old_configs="$1"
	[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
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
			printf "\e[93mLinking config files...\e[0m\n"
			if [[ "$cfg_file" == "redshift.conf" ]]; then
				mv -v "$HOME/.config/$cfg_file" "$old_configs/"
			else
				[[ -d "$old_configs/${cfg_file%/*}" ]] || mkdir -p "$old_configs/${cfg_file%/*}"
				mv -v "$HOME/.config/$cfg_file" "$old_configs/${cfg_file%/*}/${cfg_file##*/}"
			fi
			[[ -d ~/gitea/configs ]] && ln -sv ~/gitea/configs/"$cfg_file" ~/.config/"$cfg_file"
			[[ -d ~/Downloads/configs ]] && ln -sv ~/Downloads/configs/"$cfg_file" ~/.config/"$cfg_file"
		else
			printf "%s/%s not present.\n" "$HOME/.config" "$cfg_file"
		fi
	done
	[[ -d "$HOME/.config/micro/plug/bookmark" ]] || micro -plugin install bookmark
}

set_reserved_space() {
	local home_part root_part data_part rbc blk_cnt res_pct
	root_part=$(df -P | awk '$NF == "/" {print $1}')
	home_part=$(df -P | awk '$NF == "/home" {print $1}')
	data_part=$(df -P | awk '$NF == "/data" {print $1}')
	rbc=$(sudo /usr/sbin/tune2fs -l "$root_part" | awk '/Reserved block count/ {print $NF}')
	blk_cnt=$(sudo /usr/sbin/tune2fs -l "$root_part" | awk '/Block count/ {print $NF}')
	res_pct="$(bc <<< "${rbc} * 100 / ${blk_cnt}")"
	printf "e[93mSetting reserved space on root, home, data partitions...\e[0m\n"
	[[ "$res_pct" -ne 5 ]] && sudo tune2fs -m 5 "$root_part"
	[[ "$home_part" ]] && sudo tune2fs -m 0 "$home_part"
	[[ "$data_part" ]] && sudo tune2fs -m 0 "$data_part"
	printf "Partition reserved space set.\n"
}

set_swappiness() {
	local repo_dir="$1"
	if grep 'vm.swappiness' /etc/sysctl.conf >/dev/null 2>&1 || [[ -f /etc/sysctl.d/90-swappiness.conf ]]; then
		printf "Swappiness has already been set.\n"
		return
	fi
	printf "Setting swappiness...\n"
	sudo cp -v "$repo_dir"/90-swappiness.conf /etc/sysctl.d/
}

set_sleep() {
	local repo_dir="$1"
	if [[ -f /etc/systemd/sleep.conf.d/99-sleep.conf ]]; then
		printf "Sleep settings already set.\n"
		return
	fi
	printf " Disabling sleep, hibrnation, suspend settings.\n"
	[[ -d /etc/systemd/sleep.conf.d ]] || sudo mkdir -p /etc/systemd/sleep.conf.d
	sudo cp -v "$repo_dir"/99-sleep.conf /etc/systemd/sleep.conf.d/
}

no_snaps() {
	local repo_dir="$1"
	if [[ -f /etc/apt/preferences.d/nosnap.pref ]]; then
		printf "Snap packages have already been disabled.\n"
		retunn
	fi
	printf "Disabling installation of Snapd and Snap packages...\n"
	sudo cp -v "$repo_dir"/apt/nosnap.pref /etc/apt/preferences.d/
}

# Add tweaks to /etc/sudoers.d directory and set swappiness
sudoers_tweaks() {
	local repo_dir=~"$1"
	printf "\e[93mApplying password feeback...\e[0m\n"
	if [[ -f /etc/sudoers.d/0pwfeedback ]]; then
		printf "Sudo password feedback is already enabled with 0pwfeedback\n"
	else
		sudo cp -v "$repo_dir"/sudoers/0pwfeedback /etc/sudoers.d/
		sudo chmod 440 /etc/sudoers.d/0pwfeedback
	fi
	if [[ -f /etc/sudoers.d/10-timeout ]]; then
		printf "Sudo timeout has already been set.\n"
	else
		printf "\e[93mApplying sudo timeout...\e[0m\n"
		sudo cp -v "$repo_dir"/sudoers/10-timeout /etc/sudoers.d/
		sudo chmod 440 /etc/sudoers.d/10-timeout
	fi
}

link_script_dir() {
	if [[ -L ~/bin ]]; then
		printf "Script directory is already linked to cloned repository.\n"
		return
	fi
	printf "\e[93mLinking scripts repo to ~/bin...\e[0m\n"
	[[ -d ~/bin ]] && rm -rf "${HOME:?}/bin"
	[[ -d ~/gitea/scripts ]] && ln -sv ~/gitea/scripts/ ~/bin
	[[ -d ~/Downloads/scripts ]] && ln -sv ~/Downloads/scripts/ ~/bin
}

main() {
	local noOpt opt optstr OPTIND OPTARG
	local old_configs=~/old-configs
	local repo_dir=~/Downloads/configs
	[[ -d ~/gitea/configs ]] && repo_dir=~/gitea/configs
	noOpt=1
	optstr=":cdhnprstw"
	while getopts "$optstr" opt; do
		case "$opt" in
			c )
				link_config_files "$old_configs" ;;
			d )
				link_dot_files "$old_configs" ;;
			h )
				help 0 ;;
			n )
				no_snaps "$repo_dir" ;;
			p )
				set_sleep "$repo_dir" ;;
			r )
				set_reserved_space ;;
			s )
				link_script_dir ;;
			t )
				sudoers_tweaks "$repo_dir" ;;
			w )
				set_swappiness "$repo_dir" ;;
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
