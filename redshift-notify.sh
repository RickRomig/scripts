#!/usr/bin/env bash
###############################################################################
# Script Name  : redshift-notify.sh
# Description  : send notification when Redshift changes between daytlight & night settings
# Dependencies : xrandr
# Arguments    : none
# Author       : Copyright © 2024, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 28 Oct 2024
# Last updated : 03 Nov 2024 version 1.1.24308
# Comments     : Script doesn't do anything if there is no display (on a KVM or headless)
#              : Run as cron job: */10 * * * * /home/username/.local/bin/redshift-notify.sh
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

DAYTIME_FILE=/tmp/daytime
NIGHTIME_FILE=/tmp/nighttime

# brightness=$(xrandr --verbose | awk '/Brightness/ {print $2;exit}')
brightness=$(xrandr --verbose | grep -w Brightness -m1 | cut -d' ' -f2 )

if [[ "$brightness" == "1.0" && -f "$NIGHTIME_FILE" ]]; then
	rm "$NIGHTIME_FILE"
elif [[ "$brightness" != "1.0" && -f "$DAYTIME_FILE" ]]; then
	rm "$DAYTIME_FILE"
fi

if [[ "$brightness" == "1.0" && ! -f "$DAYTIME_FILE" ]]; then
	touch "$DAYTIME_FILE"
	notify-send -t 3500 "Redshift" "Changed to day setting"
elif [[ "$brightness" != "1.0" && ! -f  "$NIGHTIME_FILE" ]]; then
	touch "$NIGHTIME_FILE"
	notify-send -t 3500 "Redshift" "Changed to night setting"
fi
