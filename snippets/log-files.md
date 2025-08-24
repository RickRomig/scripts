# Log files
#### Basic rediretion:
```bash
$ ./your_script.sh > logfile.txt 2>&1
$ your_command | tee -a logfile.txt
```
#### Example script:
```bash
#!/bin/bash

LOGFILE="script_log_$(date +%Y%m%d_%H%M%S).log"

# Redirect output and errors to the log file
exec > "$LOGFILE" 2>&1	# >> appends to LOGFILE

echo "Script started at $(date)"
echo "Performing some operations..."

# Example command
mkdir /tmp/example_directory

echo "Script completed at $(date)"
```
#### Other examples:
```bash
#!/bin/bash
{
  blah code
} 2>&1 | tee -a file.log
```
```bash
exec > >(tee -a "/path/logs/$log") 2>&1
```
#### Log function:
```bash
log() {
  echo "$(date +'%F %R') - $1" >> logfile.log
}

log "This is a log message"

log() {
  local message="$1"
  local logfile="$2"
  printf "%(%F %R)T: %s\n" -1 "$message" | tee -a "$logfile"
}

dielog() {
  local -r message="$1"
  local -r logfile="$2"
  local -r errcode-"${3:-2}"
  printf "%(%F %R)T: %s\n" -1 "$message" | tee -a "$logfile" >/dev/null
  printf "\e[91mERROR:\e[0m %s\n" "$message" >&2
  exit "$errcode"
}
```
