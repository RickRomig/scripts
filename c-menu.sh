#!/usr/bin/env bash
#####################################################################
# Script Name  : c-menu.sh
# Description  : menu for C programming
# Dependencies : binutils, gcc
# Arguments    : none
# Author       : Richard Romig
# Email        : rick.romig@gmail.com
# Comment      : Run from current working directory
# TODO (rick)  :
# License      : GNU General Public License, version 2
#####################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091,SC2034

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

# Variables

_script=$(basename "$0"); readonly _script
readonly _version="0.2.0"
readonly _updated="04 Feb 2023"
readonly rederror="${lightred}Error:${normal}"

## Functions ##

check_dependencies() {
	local packages=( binutils gcc )
	check_packages "${packages[@]}"
	if exists fnloc; then printf "fnloc - OK\n"; else printf "Install fnloc from repository.\n"; fi
}

## Execution ##

check_dependencies
sleep 3
while true; do
  clear
	printf "\n%s v%s (%s)\n" "$_script" "$_version" "$_updated"
  printf "Menu for working with C source code.\n\n"
  options=("Open a file with nano" "Compile code to a.out" "Compile code with -o option" "Display Lines of Code" \
    "Print LOC to a file" "View code" "Clean up extraneous files" "Quit")
  PS3="Choose an option: "
  select opt in "${options[@]}"; do
	  case $REPLY in
	    1 )
	      read -rp "Enter filename to edit: " fname
        if [[ -f "$fname" ]]; then
          if exists micro; then
            printf "Opening %s with micro...\n" "$fname"
            /usr/bin/micro "$fname"
          else
	          printf "Opening %s with nano...\n" "$fname"
	          /usr/bin/nano "$fname"
          fi
        else
          printf "%s %s not found.\n" "$rederror" "$fname" >&2
        fi
	      break ;;
	    2 )
	      read -rp "Enter file to be compiled to a.out (with the .c extension): " fname
	      if [[ -f "$fname" ]]; then
          printf "Compiling %s to a.out\n" "$fname"
	      else
          printf "%s %s not found.\n" "$rederror" "$fname" >&2
	      fi
	      break ;;
	    3 )
	      read -rp "Enter file to be compiled (without the .c extension): " fname
	      ext="${fname##*.}"
	      [ -n "$ext" ] && fname="${fname%.*}"
	      if [[ -f "$fname.c" ]]; then
          printf "Compiling %s.c to %s\n" "$fname" "$fname"
	        /usr/bin/gcc -o "$fname"
	      else
          printf "%s %s not found.\n" "$rederror" "$fname" >&2
	      fi
	      break ;;
	    4 )
	      read -rp "Enter source code file for LOC count (Print to screen): " fname
	      if [[ -f "$fname" ]]; then
          /usr/local/bin/fnloc "$fname"
	        anykey
	      else
          printf "%s %s not found.\n" "$rederror" "$fname" >&2
	      fi
	      break ;;
	    5 )
	      read -rp "Enter source code file for LOC count (Print to file): " fname
	      if [[ -f "$fname" ]]; then
          locfile=${fname%%.*}
	        locfile+=".loc"
	        /usr/local/bin/fnloc $"$fname" > "$locfile"
	      else
          printf "%s %s not found.\n" "$rederror" "$fname" >&2
	      fi
	      break ;;
      6 )
        read -rp "Enter source code file to view: " fname
        if [[ -f "$fname" ]]; then
          if exists bat; then
            /usr/bin/bat "$fname"
          else
            viewtext "$fname"
          fi
        else
          printf "%s %s not found.\n" "$rederror" "$fname" >&2
        fi
        break ;;
      7 )
	      printf "Cleaning up ...\n"
	      /usr/bin/find . -maxdepth 1 -type f \( -name "a.out" -o -iname "*.o" -o -iname "*~" \) -print -exec rm {} \;
	      break ;;
	    8 )
	      leave "" ;;
	    *)
	      echo -e "%s Not a valid option. Please try again.\n" "$rederror" >&2 ;;
  	esac
  done
done
