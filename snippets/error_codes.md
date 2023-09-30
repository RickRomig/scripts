# Error codes

BASH Exit Status
0   success
1   failure, as defined by the program
2   command line usage error

BASH Error Codes
1   catch all error code (errors such as divide by 0 or operations not permitted.)
2   Misuse of shell builtins (Missing Keyword, command or Permission)

126 Command invoked cannot execute
127 Command not found
128 Invalid argument to exit command
128+n   Fatal error signal "n"
130 Bash script terminated by Control-C
255 Exit status out of range

```bash
function error_exit() {
    echo "${_script}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

error_exit "$LINENO: An error has occurred."

tempfiles=( )
cleanup() {
  rm -f "${tempfiles[@]}"
}
trap cleanup 0

error_line() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

trap 'error_line ${LINENO}' ERR

error_line ${LINENO} "the foobar failed" 2

error_handler() {
  echo "Error: ($1) occurred on line $2" >&2
  # exit "$1"
}

trap 'error_handler $? $LINENO' ERR

trap "exit 1" 10
PROC=$$

error() {
	echo -e "$@" >&2
	# exit 1
	kill -10 $PROC
}

[[ "$1" ]] || error "Error message\nFurther information"
[[ -f "$1" ]] || error "$1 - file does not exist."
[[ "$2" ]] || (echo "Message 1";error "$1 exists";echo "Exiting script.")
```
