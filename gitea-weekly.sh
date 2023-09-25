#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-weekly.sh
# Description  : weekly backup of gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 5 Sep 2023 Version 1.0.1
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

arc_dir="$HOME/Downloads/archives/gitea/weekly"
archive="gitea-bu-$(date +%y%m%d).tar.gz"

tar -zcf "$arc_dir/$archive" -C "$HOME" gitea
find "$arc_dir" -mtime +31 -delete
exit
