#!/usr/bin/env bash
##########################################################################
# Script Name  : sync6006.sh
# Description  : synchronize archive files to HP-6005 data drive.
# Dependencies : rsync
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 09 Dec 2023
# Last updated : 01 Feb 2025 (version 1.1.24032)
# Comments     : Run in user crontab
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

rsync -aq --delete "$HOME"/Downloads/archives/ rick@192.168.0.11:/data/archives/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/Finance/ rick@192.168.0.11:Documents/Finance/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/HomeBank/ rick@192.168.0.11:Documents/HomeBank/ 2>/dev/null
exit