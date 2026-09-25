# usage instructions for a script

### Basic usage function
```bash
usage() {
	local errcode="${1:-2}"
	echo "Usage: $_script <argument>"
	exit "$errcode"
}

usage() {
	die "Usage: $_script <argument>" 2   # default exit status is 1 if not included
}
```
### Usage function with example
```bash
usage() {
	local errcode="${1:-2}"
	echo "Usage: $script <file>"
	echo "Example: $script some-file.txt"
	exit "$errcode"
}
```
### Declared variables
```bash
# script=$(basename "$0")
script=${0##*/}
```
### Notes:
errcode in usage function defaults to 2 since most errors that call the fucntion will be related to command-line arguments, options, and parameters.
