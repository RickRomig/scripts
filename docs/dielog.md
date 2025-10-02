# dielog
### Purpose
Display an error message, write it to a log file, and exit the script### Arguments
- Message to be logges/displayed
- Path to log file (Unless current directory, full or relative path)
- Error code for exit command
### Returns
Nothing
### Usage
```bash
logfile="$HOME/.local/share/log/error.log"
command || dielog "Command failed" "$logfile" 1
```
### Code
```bash
dielog() {
  local message="$1"
  local log_file="$2"
  local err_code="${3:-1}"
  printf "%(%F %R)T: \e[91mERROR:\e[0m %s\n" -1 "$message" | tee -a "$log_file"
  exit "$err_code"
}
```
### Notes
Should be used for errors that require the script to be terminated.
