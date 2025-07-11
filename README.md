# scripts

## Description

This repository contains Bash scripts I use on my local network, along with support files, code snippets, templates, and documentation.

## License
Copyright © 2025, Richard B. Romig
Programs in this repository are licensed under the GNU General Public Licencse, version 2 which can be found in the [repository](https://github.com/RickRomig/scripts/blob/main/LICENSE)

## Function Library

The `functionlib` script is a collection of commonly used functions which I use in most of my scripts. To use it, simply source it near the begining of the script. Since I use Shellcheck as my linter, I include directives to tell Shellcheck the location of the script and to disable the error message it gives about it. To use it, place the following code directory beneath the header information:
```bash
## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091 # Disabling SC1091 is not required if using shellcheck -x to check syntax.

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi
```

## Directories

### cronjobs

Scripts that are run as cron jobs.

### files

Support files called by scripts. These files include sed scripts, audio files, and files to be appended or prepended to other files.

### functions

Supporting documentation for functions contained in `functionlib`, `.bashrc`, abd `.bash_aliases` files. The directory also contains examples of routines I commonly use in my scripts that are not in functions.

### snippets

Code snippets and code examples, formatted as markdown files.

### Templates

Templates for shell scripts, C/C++ source code, configuration files, and open-source licenses.

## Terms and conditions
These programs are free software; you can redistribute them and/or modify them under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

These programs are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

#### Rick Romig (*The Luddite Geek*)
##### 10 Jul 2025