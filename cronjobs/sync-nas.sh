#!/usr/bin/env bash
##########################################################################
# Script Name  : sync-nas.sh
# Description  : Use rsync to copy files from hp-800g2-sff (#10) to NAS.
# Dependencies : rsync
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 Nov 2023
# Last updated : 21 Jul 2025 Version 1.2.25202
# Comments     : Run as a user cron job on hp-800g2-sff (#10)
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

rsync -aq --delete "$HOME"/Downloads/archives/ rick@192.168.0.4:archives/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/Finance/Archives/ rick@192.168.0.4:Documents/Finance/Archives/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/mosfanet/ rick@192.168.0.4:Documents/mosfanet/ 2>/dev/null
exit
