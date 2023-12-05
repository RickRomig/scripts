#!/usr/bin/env bash
##########################################################################
# Script Name  : sync-nas.sh
# Description  : Use rsync to copy files from hp-800g2-sff (#10) to NAS.
# Dependencies : rsync
# Arguments    : None
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 19 Nov 2023
# Last updated : 04 Dec 2023 Version 0.1.1
# Comments     : Run as a user cron job on hp-800g2-sff (#10)
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

rsync -aq --delete "$HOME"/Downloads/archives/ rick@192.168.0.4:archives/ 2>/dev/null
rsync -aq --delete "$HOME"/Documents/mosfanet/ rick@192.168.0.4:Documents/mosfanet/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/finance/ rick@192.168.0.4:archives/finance/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/gitea/ rick@192.168.0.4:archives/gitea/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/gitea-repo/ rick@192.168.0.4:archives/gitea-repo/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/projects-repo/ rick@192.168.0.4:archives/projects-repo/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/scripts/ rick@192.168.0.4:archives/scripts/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/homebank/ rick@192.168.0.4:archives/homebank/ 2>/dev/null
# rsync -aq --delete "$HOME"/Downloads/archives/homepage/ rick@192.168.0.4:archives/homepage/ 2>/dev/null
exit
