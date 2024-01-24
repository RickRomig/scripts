#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-backup.sh
# Description  : rsync backup of gitea archives to gitea server
# Dependencies : rync
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 24 Jan 2024 Version 1.0.3
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

rsync -aq --delete "$HOME"/Downloads/archives/gitea/ rick@192.168.0.16:Downloads/archives/gitea/
exit
