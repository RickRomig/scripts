#!/usr/bin/env bash
##########################################################################
# Script Name  : link-configs.sh
# Description  : Create symbolic links for configuration files.
# Dependencies : None
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 09 Aug 2025
# Last updated : 09 Aug 2025
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

set -eu

## Global Variables ##

readonly old_configs="$HOME/old-configs/"

## Functions ##

# Create symbolic links to dotfiles in the home directory
link_dotfiles() {
	local dot_file dot_files
	local repo_dir="$1"
	dot_files=(
		.bash_aliases
		.bashrc
		.bash_logout
		.curlrc
		.face
		.imwheelrc
		.inputrc
		.profile
		.wgetrc
	)
	printf "\e[93m93mLinking dotfiles ...\e[0m\n"
	for dot_file in "${dot_files[@]}"; do
		printf "\e[93mLinking %s ...\e[0m\n" "$dot_file"
		[[ -f "$HOME/$dot_file" ]] && mv -v "$HOME/$dot_file" "$old_configs"
		ln -sv "$repo_dir/$dot_file" "$HOME/$dot_file"
	done
}

# Link configuration files to directories in ~/.config
link_configs() {
	local file files
	local repo_dir="$1"
	local -r config_dir="$HOME/.config"
	files=(
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
	for file in "${files[@]}"; do
		if [[ -f "$config_dir/$file" ]]; then
			printf "\e[93mLinking %s to %s ...\e[0m\n" "$repo_dir/$file" "$config_dir"
			if [[ "$file" == "redshift.conf" ]]; then
				mv -v "$config_dir/$file" "$old_configs/"
			else
				[[ -d "$old_configs/${file%/*}" ]] || mkdir -p "$old_configs/${file%/*}"
				mv -v "$config_dir/$file" "$old_configs/${file%/*}/${file##*/}"
			fi
			ln -sv "$repo_dir/$file" "$config_dir/$file"
		fi
	done
	[[ -d "$HOME/.config/micro/plug/bookmark" ]] || micro -plugin install bookmark
}

# Add tweaks to /etc/sudoers.d directory and set swappiness
set_system_tweaks() {
	printf "\e[93mApplying password feeback...\e[0m\n"
	if [[ ! -f "/etc/sudoers.d/0pwfeedback" ]]; then
		sudo cp -v "$repo_dir/sudoers/0pwfeedback" /etc/sudoers.d/ | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
		sudo chmod 440 /etc/sudoers.d/0pwfeedback
	fi
	if [[ ! -f "/etc/sudoers.d/10timeout" ]]; then
		printf "\e[93mApplying sudo timeout...\e[0m\n"
		sudo cp -v "$repo_dir/sudoers/10timeout" /etc/sudoers.d/ | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
		sudo chmod 440 /etc/sudoers.d/10timeout
	fi
	printf "\e[93mApplying swappiness...\e[0m\n"
	grep -q 'vm.swappiness=10' || echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
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
	printf "\e[93mLinking scripts repo to ~/bin...\e[0m\n"
	[[ -d "$HOME/bin" ]] && rm -rf "${HOME:?}/bin"
	ln -vs "$script_repo/" "$HOME/bin"
}

main() {
  local -r script="${0##*/}"
  local -r version="1.0.25221"
	local repo_dir
	repo_dir=$(assign_cfg_repo)
	[[ -d "$old_configs" ]] || mkdir -p "$old_configs"
	link_dotfiles "$repo_dir"
	link_configs "$repo_dir"
	set_system_tweaks
	link_script_dir
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
