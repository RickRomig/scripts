#!/usr/bin/env bash
##########################################################################
# Script Name  : redshift-notify.sh
# Description  : send notification when Redshift changes between daytlight & night settings
# Dependencies : xrandr
# Arguments    : none
# Author       : Copyright © 2024, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 28 Oct 2024
# Last updated : 21 Jul 2025 version 1.3.25202
# Comments     : Script doesn't do anything if there is no display (on a KVM or headless)
#              : Checks if Redshift has changed brightness.
#              : Run as cron job: */10 * * * * /home/username/.local/bin/redshift-notify.sh
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

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

DAY_FILE=/tmp/daytime
NIGHT_FILE=/tmp/nighttime

brightness=$(xrandr --verbose | grep -w Brightness -m1 | cut -d' ' -f2 )

if [[ "$brightness" == "1.0" && -f "$NIGHT_FILE" ]]; then
	rm "$NIGHT_FILE"
elif [[ "$brightness" != "1.0" && -f "$DAY_FILE" ]]; then
	rm "$DAY_FILE"
fi

if [[ "$brightness" == "1.0" && ! -f "$DAY_FILE" ]]; then
	touch "$DAY_FILE"
	notify-send -t 3500 -i "$HOME/.icons/sun-custom.png" "Redshift" "Changed to day setting"
elif [[ "$brightness" != "1.0" && ! -f  "$NIGHT_FILE" ]]; then
	touch "$NIGHT_FILE"
	notify-send -t 3500 -i "$HOME/.icons/sunset-fill-red.png" "Redshift" "Changed to night setting"
fi
