#!/usr/bin/env bash
##########################################################################
# Script Name  : cam.sh
# Description  : Cards Against Muggles, a Cards Against Humanity card game
# Dependencies : fzf, cam-black.lst, cam-white.list
# Arguments    : See help() function for available options.
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 23 Mar 2025
# Last updated : 25 Mar 2025
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

main() {
  local black_card white_card choices cards line script version card_dir black_file white_file
  script=$(basename "$0")
  version="1.1.25084"
  card_dir="$HOME/.local/share/doc"
  black_file="cam-black.lst"
  white_file="cam-white.lst"

  # Create the arrays
  mapfile -t black_cards < "$card_dir/$black_file"
  mapfile -t white_cards < "$card_dir/$white_file"

  while true; do
    clear
    unset cards
    black_card=$(printf "%s\n" "${black_cards[@]}" | shuf -n 1)
    white_card=$(printf "%s\n" "${white_cards[@]}" | shuf -n 10)

    IFS=$'\n'
    while read -r line; do cards+=("$line"); done <<< "$white_card"
    # choices=("$($FMENU "Choose cards" < <(printf "%s\n" "${cards[@]}"))")
    choices=("$(fzf --header="$black_card" --layout=reverse --border=bold --border=rounded --margin=5% --multi --prompt "Choose cards" < <(printf "%s\n" "${cards[@]}"))")

    printf "\n%s\n" "$black_card"
    printf "%s\n\n" "${choices[@]}"
    read -rsn1 -p "Press q to quit." ans
    [[ "${ans,}" == "q" ]] && break
  done
  printf '\e[A\e[K'
  printf "\nI hope you enjoyed playing Cards Against Muggles.\n"
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
