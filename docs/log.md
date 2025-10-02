# log
### Purpose
Display an error or informational message and write it to a log file.
### Arguments
- Message to be logges/displayed
- Path to log file (Unless current directory, full or relative path)
### Returns
Nothing
### Usage
```bash
logfile="$HOME/.local/share/log/error.log"
command ||dielog "An error occured" "$logfile"
```
### Code
```bash
log() {
  local message="$1"
  local logfile="$2"
  printf "%(%F %R)T: %s\n" -1 "$message" | tee -a "$log_file"
}
```
### Notes
Should be used for informational messages and non-critical errors.
