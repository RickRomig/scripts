#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-backup.sh
# Description  : rsync backup of gitea archives to gitea server
# Dependencies : rync
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 5 Sep 2023 Version 1.0.1
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

rsync -a --delete "$HOME"/Downloads/archives/gitea/ rick@192.168.0.16:Downloads/archives/gitea/
exit
