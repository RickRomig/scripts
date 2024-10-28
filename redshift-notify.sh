#!/usr/bin/env bash
###############################################################################
# Script Name  : redshift-notify.sh
# Description  : send notification when Redshift changes between daytlight & night settings
# Dependencies : xrandr
# Arguments    : none
# Author       : Copyright © 2024, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 28 Oct 2024
# Last updated : 28 Oct 2024 version 1.0.24302
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
###############################################################################

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

DAYTIME_FILE=/tmp/daytime
NIGHTIME_FILE=/tmp/nighttime

brightness=$(xrandr --verbose | awk '/Brightness/ {print $2;exit}')

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
