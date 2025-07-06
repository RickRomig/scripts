#!/usr/bin/env bash
##########################################################################
# Script Name  : repo-backup.sh
# Description  : rsync backup of gitea archives to gitea server
# Dependencies : rync
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 25 May 2024 Version 1.3.24146
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -eu

rsync -aq --delete "$HOME"/gitea/ rick@192.168.0.16:gitea/
rsync -aq --delete "$HOME"/Projects/ rick@192.168.0.16:Projects/
exit
