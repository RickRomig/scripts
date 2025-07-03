#!/usr/bin/env bash
##########################################################################
# Script Name  : battery-notify-install.sh
# Description  : Installs scripts & supporting files to provide notificaions for battery events.
# Dependencies : git
# Arguments    : None
# Author       : Copyright © 2024 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 21 Oct 2024
# Last updated : 03 Jul 2025
# Comments     : Not needed if a power manager is already installed, i.e., xfce4-power-manager
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
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

readonly script="${0##*/}"
readonly version="1.4.25184"

## Functions ##

install_scripts() {
	local batt
	local repo="$1"
	local dest_dir="HOME/.local/bin"
	local batt_array=(battery-alert battery-charging)
	local source_dir="$repo/.local/bin"
	printf "Copying the battery scripts...\n"
	for batt in "${batt_array[@]}"; do
		cp -v "$source_dir/$batt" "$dest_dir/" | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
	done
}

install_icons() {
	local icon icon_dir icon_array source_dir repo
	repo="$1"
	icon_dir="$HOME/.local/share/icons/dunst"
	icon_array=(battery-alert.svg battery-charging.svg battery-discharging.svg battery.svg)
	[[ -d "$icon_dir" ]] || mkdir -p "$icon_dir"
	source_dir="$repo/.local/share/icons/battery"
	printf "Copying the battery icons...\n"
	for icon in "${icon_array[@]}"; do
		cp -v "$source_dir/$icon" "$icon_dir/" | awk -F"/" '{print "==> " $NF}' | sed "s/'$//"
	done
}

remove_icons() {
	local icon_dir
	icon_dir="$HOME/.local/share/icons/battery"
	printf "Removing battery notification icons ...\n"
	rm -rf "$icon_dir"
}

apply_power_rules() {
	local repo="$1"
	local -r  rules_file="60-power.rules"
	local -r dest_dir="/etc/udev/rules.d"
	sudo_login 2
	printf "Copying %s to %s.\n" "$rules_file" "$dest_dir"
	sudo cp -v "$repo/$rules_file" "$dest_dir/" | awk '{print "==> " $NF}' | sed "s/'//g"
}

remove_notifier() {
	local batt
	local bin_dir="$HOME/.local/bin"
	local rules_dir="/etc/udev/rules.d"
	local rules_file="60-power.rules"
	local batt_array=(battery-alert battery-charging)
	[[ -f "$rules_dir/$rules_file" ]] || leave "Battery notification scripts & power rules not installed."
	sudo_login 2
	printf "Removing battery notification scripts ...\n"
	for batt in "${batt_array[@]}"; do rm -v "$bin_dir/batt"; done
	printf "Removing Power Rules ...\n"
	sudo rm -v "$rules_dir/$rules_file"
	default_no "Remove battery notification icons? " && remove_icons
	printf "If there is a cron job for %s, you need to remove it from the crontab.\n" "${batt_array[0]}"
}

assign_repository() {
	local localip repository
	localip=$(local_ip)
	case "$localip" in
		12|13|23|24 )
			printf "Cloning the i3debian repository from the Gitea Server.\n"
			repository="$HOME/Downloads/i3debian"
			git clone "$GITEA_URL/i3debian.git" "$repository/"
			install_notifier_scripts "$repository"
			;;
		10|16|22 )
			printf "Using the i3debian repository mirror on the system.\n"
			repository="$HOME/gitea/i3debian"
			install_notifier_scripts "$repository"
			;;
		* )
			printf "System is not a laptop running the i3 window manager.\n"
			over_line "$script v$version" "-"
			exit
	esac
}

install_notifier_scripts() {
	local repository="$1"
	sudo_login 2
	install_scripts "$repository"
	install_icons "$repository"
	apply_power_rules "$repository"
	printf "Reboot for the changes to take effect.\n"
	cron_notice
	# [[ -d "$HOME/Downloads/i3debian" ]] && rm -rf "$HOME/Downloads/i3debian"
}

cron_notice() {
	cat << _CRON_
To run the battery-alert script, you will need to set up a cron job. In a
terminal, launch crontab -e and enter the job as follows:

*/5 * * * * /home/rick/.local/bin/battery-alert

This will run the job every 5 minutes. The time interval can be changed.
This script defaults to check battery 0. Change as required.
_CRON_
}

main() {
	check_package git
	printf "Installs/Removes scripts and files for notification of battery status.\n"
	if [[ "$#" -eq 0 ]]; then
		printf "To install the battery notification scripts, enter %s --install\n" "$script"
		printf "To remove the battery notification scripts, enter %s --remove\n " "$script"
	elif [[ "$1" == "--install" || "$1" == "-i" ]]; then
		assign_repository
	elif [[ "$1" == "--remove" || "$1" == "-r" ]]; then
		remove_notifier
	fi
  over_line "$script v$version" "-"
  exit
}

## Execution ##

main "$@"
