#!/usr/bin/env bash
#####################################################################
# Script Name  : c-menu.sh
# Description  : menu for C programming
# Dependencies : none
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
  echo -e "\e[91mERROR:\e[0m functionlib not found!" >&2
  exit 1
fi

# Variables

readonly _script=$(basename "$0")
readonly _version="0.1.8"
readonly _updated="12 Jul 2021"

## Execution ##

while true; do
  clear
  echo $'\n'$"$_script v$_version ($_updated)"
  echo -e "Menu for working with C source code.\n"
  options=("Open a file with nano" "Compile code to a.out" \
    "Compile code with -o option" "Display Lines of Code" \
    "Print LOC to a file" "View code" "Clean up extraneous files" "Quit")
  PS3="Choose an option: "
  select opt in "${options[@]}"; do
	  case $REPLY in
	    1 )
	      read -rp "Enter filename to edit: " fname
        if [[ -f "$fname" ]]; then
          if exists micro; then
            echo "Opening $fname with micro..."
            /usr/bin/micro "$fname"
          else
	          echo "Opening $fname with nano..."
	          /usr/bin/nano "$fname"
          fi
        else
          echo "${lightred}Error: $fname not found.${normal}" >&2
        fi
	      break ;;
	    2 )
	      read -rp "Enter file to be compiled to a.out (with the .c extension): " fname
	      if [[ -f "$fname" ]]; then
          echo "Compiling $fname to a.out"
	        /usr/bin/gcc "$fname"
	      else
          echo "${lightred}Error: $fname not found.${normal}" >&2
	      fi
	      break ;;
	    3 )
	      read -rp "Enter file to be compiled (without the .c extension): " fname
	      ext="${fname##*.}"
	      [ -n "$ext" ] && fname="${fname%.*}"
	      if [[ -f "$fname.c" ]]; then
          echo "Compiling $fname.c to $fname"
	        /usr/bin/gcc -o "$fname"
	      else
          echo "${lightred}Error: $fname.c not found${normal}" >&2
	      fi
	      break ;;
	    4 )
	      read -rp "Enter source code file for LOC count (Print to screen): " fname
	      if [[ -f "$fname" ]]; then
          /usr/local/bin/fnloc "$fname"
	        anykey
	      else
          echo "${lightred}Error: $fname not found.${normal}" >&2
	      fi
	      break ;;
	    5 )
	      read -rp "Enter source code file for LOC count (Print to file): " fname
	      if [[ -f "$fname" ]]; then
          locfile=${fname%%.*}
	        locfile+=".loc"
	        /usr/local/bin/fnloc $"$fname" > "$locfile"
	      else
          echo "${lightred}Error: $fname not found.${normal}" >&2
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
          echo "${lightred}Error: $fname not found.${normal}" >&2
        fi
        break ;;
      7 )
	      echo "Cleaning up ..."
	      /usr/bin/find . -maxdepth 1 -type f \( -name "a.out" -o -iname "*.o" -o -iname "*~" \) -print -exec rm {} \;
	      break ;;
	    $8 )
	      leave "" ;;
	    *)
	      echo -e "${lightred}Not a valid option. Please try again.${normal}" >&2 ;;
  	esac
  done
done
