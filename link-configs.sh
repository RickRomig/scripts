#!/usr/bin/env bash
##########################################################################
# Script Name  : link-configs.sh
# Description  : Create symbolic links for configuration files.
# Dependencies : git
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 09 Aug 2025
# Last updated : 04 Sep 2025
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
readonly version="2.1.25247"
readonly old_configs="$HOME/old-configs/"

## Functions ##

help() {
	local errcode="${1:-2}"
	local -r updated="04 Sep 2025"
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
	printf "\e[93m93mLinking dotfiles ...\e[0m\n"
	for dot_file in "${dot_files[@]}"; do
		printf "\e[93mLinking %s ...\e[0m\n" "$dot_file"
		[[ -f "$HOME/$dot_file" ]] && mv -v "$HOME/$dot_file" "$old_configs"
		ln -sv "$repo_dir/$dot_file" "$HOME/$dot_file"
	done
}

# Link configuration files to directories in ~/.config
link_config_files() {
	local cfg_file cfg_files repo_dir
	repo_dir=$(assign_cfg_repo)
	local -r config_dir="$HOME/.config"
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
		if [[ -f "$config_dir/$cfg_file" ]]; then
			printf "\e[93mLinking %s to %s ...\e[0m\n" "$repo_dir/$cfg_file" "$config_dir"
			if [[ "$cfg_file" == "redshift.conf" ]]; then
				mv -v "$config_dir/$cfg_file" "$old_configs/"
			else
				[[ -d "$old_configs/${cfg_file%/*}" ]] || mkdir -p "$old_configs/${cfg_file%/*}"
				mv -v "$config_dir/$cfg_file" "$old_configs/${cfg_file%/*}/${cfg_file##*/}"
			fi
			ln -sv "$repo_dir/$cfg_file" "$config_dir/$cfg_file"
		else
			printf "%s/%s not present.\n" "$config_dir" "$cfg_file"
		fi
	done
	[[ -d "$HOME/.config/micro/plug/bookmark" ]] || micro -plugin install bookmark
}

# Add tweaks to /etc/sudoers.d directory and set swappiness
set_system_tweaks() {
	local repo_dir
	repo_dir=$(assign_cfg_repo)
	printf "\e[93mApplying password feeback...\e[0m\n"
	if [[ -f "/etc/sudoers.d/0pwfeedback" ]]; then
		printf "Sudo password feedback is already enabled with 0pwfeedback\n"
	else
		sudo cp -v "$repo_dir/sudoers/0pwfeedback" /etc/sudoers.d/ | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
		sudo chmod 440 /etc/sudoers.d/0pwfeedback
	fi
	if [[ -f "/etc/sudoers.d/10timeout" ]]; then
		printf "Sudo timeout has already been set.\n"
	else
		printf "\e[93mApplying sudo timeout...\e[0m\n"
		sudo cp -v "$repo_dir/sudoers/10timeout" /etc/sudoers.d/ | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
		sudo chmod 440 /etc/sudoers.d/10timeout
	fi
	printf "\e[93mApplying swappiness...\e[0m\n"
	grep -q 'vm.swappiness=10' /etc/sysctl.conf || echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
	if [[ -f "/etc/apt/preferences.d/nosnap.pref" ]]; then
		printf "Snap packages have already been disabled.\n"
	else
		printf "Disabling installation of Snapd and Snap packages...\n"
		sudo cp -v "$repo_dir/apt/nosnap.pref" /etc/apt/preferences.d/ | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
	fi
}

assign_scripts_repo() {
	local local_host="${HOSTNAME:-$(hostname)}"
	local repo_dir="$HOME/Downloads/scripts"
	case "$local_host" in
		hp-800g2-sff|hp-8300-usdt|hp-850-g3 )
			repo_dir="$HOME/gitea/scripts" ;;
		* )
			if [[ -d "$repo_dir" ]]; then
				pushd "$repo_dir" || die "pushd failed"
				git pull --quiet
				popd || die "popd failed"
			else
				git clone --quiet "$GITHUB_URL/scripts.git" "$repo_dir"
			fi
	esac
	printf "%s" "$repo_dir"
}

link_script_dir() {
	local script_repo
	script_repo=$(assign_scripts_repo)
	if [[ -d "$HOME/gitea/scripts" ]]; then
		printf "Script directory is already linked to repository.\n"
	elif [[ -L "$HOME/bin" ]]; then
		printf "Script directory is already linked to cloned repository.\n"
	else
		printf "\e[93mLinking scripts repo to ~/bin...\e[0m\n"
		[[ -d "$HOME/bin" ]] && rm -rf "${HOME:?}/bin"
		ln -sv "$script_repo/" "$HOME/bin"
	fi
}

main() {
	local noOpt opt optstr OPTIND OPTARG
	noOpt=1
	optstr=":cdhst"
	while getopts "$optstr" opt; do
		case "$opt" in
			c )
				[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
				link_config_files ;;
			d )
				[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
				link_dot_files ;;
			h )
				help 0 ;;
			s )
				link_script_dir ;;
			t )
				set_system_tweaks ;;
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
