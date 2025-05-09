# error_handler
### Purpose
Displays error code and line number for a trapped error.
### Arguments
Error code and line number returned by the trap builtin.
### Usage
```bash
trap 'error_handler $? $LINENO' ERR
sudo apt fnloc
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package fnloc
ERROR: (100) occurred on line 42
```
### Code
```bash
error_handler() {
  local err_code="$1"
  local line_nr="$2"
  printf "\e[91mERROR:\e[0m (%s) occurred on line %s\n" "$err_code" "$line_nr" >&2
  exit "$err_code"
}

trap 'error_handler $? $LINENO' ERR
```
### Notes
This function should not be used in a script with functions that return an integer that is not meant to be an error, i.e., an IP address or TRUE/FALSE.
