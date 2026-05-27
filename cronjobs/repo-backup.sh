#!/usr/bin/env bash
##########################################################################
# Script Name  : repo-backup.sh
# Description  : rsync backup of gitea archives to gitea server
# Dependencies : rync
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 26 May 2026
# Version      : 1.4.26146
# Comments     :
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

rsync -aq --delete "$HOME"/gitea/ rick@192.168.0.16:gitea/
rsync -aq --delete "$HOME"/Projects/ rick@192.168.0.16:Projects/
exit
