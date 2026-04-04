# dielog
### Purpose
Display an error message, write it to a log file, and exit the script
### Arguments
$1 -> message to be displayed and logged
$2 -> path/to/logfile
$3 -> Exit status (optional, default is 1)
### Returns
Nothing
### Usage
```bash
logfile="$HOME/.local/share/log/error.log"
command || dielog "Command failed" "$logfile" 1
```
### Notes
Should be used for errors that require the script to be terminated.
