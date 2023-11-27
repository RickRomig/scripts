#!/usr/bin/env bash
##########################################################################
# Script Name  : gitea-monthly.sh
# Description  : monthly backup of gitea repositories
# Dependencies : none
# Arguments    : none
# Author       : Copyright © 2023 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.net
# Created      : 16 Sep 2023
# Last updated : 27 Nov 2023 Version 1.0.4
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

set -euo pipefail

arc_dir="$HOME/Downloads/archives/gitea/monthly"
archive="gitea-bu-$(date +%y%m%d).tar.gz"

tar -zpcf "$arc_dir/$archive" -C "$HOME" gitea
find "$arc_dir" -mtime +365 -delete
exit
