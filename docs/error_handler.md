# error_handler
### Purpose
Displays error code and line number for a trapped error.
### Arguments
$1 -> Error code passed by trap builtin
$2 -> Line number of error passed by trap builtin
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
### Notes
This function should not be used in a script with functions that return an integer that is not meant to be an error, i.e., an IP address or TRUE/FALSE.
