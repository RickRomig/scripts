#!/usr/bin/env bash
##########################################################################
# Script Name  : cam.sh
# Description  : Cards Against Muggles, a Cards Against Humanity card game
# Dependencies : fzf, cam-black.lst, cam-white.list
# Arguments    : none
# Author       : Copyright © 2025 Richard B. Romig, Mosfanet
# Email        : rick.romig@gmail | rick.romig@mymetronet.net
# Created      : 23 Mar 2025
# Last updated : 22 Sep 2025
# Comments     :
# TODO (Rick)  :
# License      : GNU General Public License, version 2.0
# License URL  : https://github.com/RickRomig/scripts/blob/main/LICENSE
##########################################################################
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
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

script_dir=$(dirname "$(readlink -f "${0}")"); readonly script_dir
readonly card_files=(cam-black.lst cam-white.lst)
readonly card_dir="$script_dir/files"

## Functions ##

check_files() {
  local file
  check_package fzf
  for file in "${card_files[@]}"; do
    if [[ -f "$card_dir/$file" ]]; then
      printf "%s [OK]\n" "$file"
      sleep 1
      printf '\e[A\e[K'
    else
      die "$file not found!" 1
    fi
  done
}

play_game() {
  local black_file white_file black_cards white_cards question_card answer_cards cards choices line ans
  black_file="${card_files[0]}"
  white_file="${card_files[1]}"

  # Create the arrays
  mapfile -t black_cards < "$card_dir/$black_file"
  mapfile -t white_cards < "$card_dir/$white_file"

  while true; do
    clear
    unset cards
    # Draw and dispaly the question card
    question_card=$(printf "%s\n" "${black_cards[@]}" | shuf -n 1)
    # Draw and display the answer cards
    answer_cards=$(printf "%s\n" "${white_cards[@]}" | shuf -n 15)

    # Select answer card(s)
    IFS=$'\n'
    while read -r line; do cards+=("$line"); done <<< "$answer_cards"
    choices=("$(fzf --header="$question_card" --layout=reverse --border=bold --border=rounded --margin=5% --multi --prompt "Choose cards" < <(printf "%s\n" "${cards[@]}"))")

    # Display question card and selected answer cards
    box "Cards Against Muggles" "*"
    printf "\n%s\n" "$question_card"
    printf "%s\n\n" "${choices[@]}"
    read -rsn1 -p "Press any key to continue,  q to quit." ans
    [[ "${ans,}" == "q" ]] && break
  done
  printf '\e[A\e[K'
  printf "\nI hope you enjoyed playing Cards Against Muggles.\n"
}

main() {
  local script="${0##*/}"
  local version="2.3.25265"
  check_files
  play_game
  over_line "$script $version"
  exit
}

## Execution ##

main "$@"
