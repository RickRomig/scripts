#!/usr/bin/env bash
#####################################################################
# Script Name  : c-menu.sh
# Description  : menu for C programming
# Dependencies : binutils, gcc
# Arguments    : none
# Author       : Richard Romig
# Email        : rick.romig@gmail.com
# Created      :
# Updated      : 13 Aug 2024
# Comments     : Run from current working directory
# TODO (rick)  :
# License      : GNU General Public License, version 2
#####################################################################

## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib

## Load function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi

# Variables

_script=$(basename "$0"); readonly _script
readonly _version="2.4.24226"
readonly _updated="13 Aug 2024"

## Functions ##

check_dependencies() {
	local packages=( binutils gcc )
	check_packages "${packages[@]}"
	if locate glibc > /dev/null 2>&1; then printf "glibc - OK\n"; else sudo apt-get install glibc-source -yy2; fi
	if [[ -d "/usr/include" ]]; then printf "build-essential - OK\n"; else sudo apt-get install build-essential -yyq; fi
	if exists fnloc; then printf "fnloc - OK\n"; else printf "Install fnloc from repository.\n"; fi
}

## Execution ##

check_dependencies
while true; do
  clear
	printf "\n%s v%s (%s)\n" "$_script" "$_version" "$_updated"
  printf "Menu for working with C source code.\n\n"
  options=("Open a file with nano" "Compile code to a.out" "Compile code with -o option" "Display Lines of Code" \
    "Print LOC to a file" "View code" "Clean up extraneous files" "Quit")
  PS3="Choose an option: "
  select _opt in "${options[@]}"; do
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
          printf "%s %s not found.\n" "$red_error" "$fname" >&2
        fi
	      break ;;
	    2 )
	      read -rp "Enter file to be compiled to a.out (with the .c extension): " fname
	      if [[ -f "$fname" ]]; then
          printf "Compiling %s to a.out\n" "$fname"
	      else
          printf "%s %s not found.\n" "$red_error" "$fname" >&2
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
          printf "%s %s not found.\n" "$red_error" "$fname" >&2
	      fi
	      break ;;
	    4 )
	      read -rp "Enter source code file for LOC count (Print to screen): " fname
	      if [[ -f "$fname" ]]; then
          /usr/local/bin/fnloc "$fname"
	        anykey
	      else
          printf "%s %s not found.\n" "$red_error" "$fname" >&2
	      fi
	      break ;;
	    5 )
	      read -rp "Enter source code file for LOC count (Print to file): " fname
	      if [[ -f "$fname" ]]; then
          locfile=${fname%%.*}
	        locfile+=".loc"
	        /usr/local/bin/fnloc $"$fname" > "$locfile"
	      else
          printf "%s %s not found.\n" "$red_error" "$fname" >&2
	      fi
	      break ;;
      6 )
        read -rp "Enter source code file to view: " fname
        if [[ -f "$fname" ]]; then
          if exists bat; then
            "$HOME"/.local/bin/bat "$fname"
          else
            viewtext "$fname"
          fi
        else
          printf "%s %s not found.\n" "$red_error" "$fname" >&2
        fi
        break ;;
      7 )
	      printf "Cleaning up ...\n"
	      /usr/bin/find . -maxdepth 1 -type f \( -name "a.out" -o -iname "*.o" -o -iname "*~" \) -print -exec rm {} \;
	      break ;;
	    8 )
	      leave "" ;;
	    *)
	      printf "%s Not a valid option. Please try again.\n" "$red_error" >&2 ;;
  	esac
  done
done
