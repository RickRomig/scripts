#!/usr/bin/env bash
##########################################################################
# Script Name  : sync6005.sh
# Description  : synchronize archive files to HP-6005 data drive.
# Dependencies : rsync
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 09 Dec 2023
# Last updated : 21 Jul 2025
# Version      : 1.2.25202
# Comments     : Run in user crontab of main system
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

rsync -aq --delete "$HOME"/Downloads/archives/ rick@192.168.0.11:/data/archives/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/Finance/ rick@192.168.0.11:Documents/Finance/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/HomeBank/ rick@192.168.0.11:Documents/HomeBank/ 2>/dev/null
exit