#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-daily.sh
# Description  : daily backup of gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 16 Sep 2023 Version 1.0.0
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

tar -zcf /home/rick/Downloads/archives/gitea/daily/gitea-bu-"$(date +%y%m%d)".tar.gz -C "$HOME" gitea
find /home/rick/Downloads/archives/gitea/daily/* -mtime +7 -delete
exit
