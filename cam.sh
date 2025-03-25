#!/usr/bin/env bash
##########################################################################
# Script Name  : cam.sh
# Description  : Cards Against Muggles, a Cards Against Humanity card game
# Dependencies : fzf, cam-black.lst, cam-white.list
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 23 Mar 2025
# Last updated : 23 Mar 2025
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
##########################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

set -eu

## Global Variables ##

script=$(basename "$0"); readonly script
readonly version="1.0.25082"
readonly card_dir="$HOME/.local/share/doc"
readonly black_file="cam-black.lst"
readonly white_file="cam-white.lst"

## Functions ##

main() {
  local black_card white_card choices cards line
  mapfile -t black_cards < "$card_dir/$black_file"
  mapfile -t white_cards < "$card_dir/$white_file"
  while true; do
    clear
    unset cards
    printf "Black card in play:\n"
    black_card=$(printf "%s\n" "${black_cards[@]}" | shuf -n 1)
    printf "%s\n" "$black_card"
    printf "\nCards in my hand:\n"
    white_card=$(printf "%s\n" "${white_cards[@]}" | shuf -n 10)
    printf "%s\n" "$white_card"

    IFS=$'\n'
    while read -r line; do cards+=("$line"); done <<< "$white_card"
    choices=("$(fzf --header="$black_card" --layout=reverse --multi --prompt "Choose cards" < <(printf "%s\n" "${cards[@]}"))")
    printf "\n%s\n" "$black_card"
    printf "%s\n" "${choices[@]}"
    anykey
  done
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
