#!/usr/bin/env bash
###############################################################################
# Script Name  : speedtest.sh
# Description  :
# Dependencies :
# Arguments    :
# Author       : Copyright © 2025, Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail.com | rick.romig@mymetronet.com
# Created      : 20 Jul 2025
# Last updated : 20 Jul 2025
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
########################################################################### This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.
# online speed test
##########################################################################

curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
exit
