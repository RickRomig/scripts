# format_time
### Purpose
Display the elasped time for the running of a script
### Arguments
SECONDS (environmental variable)
### Usage
```bash
SECONDS=0
# Contents of the script...
echo "Script completed in $(format_time $SECONDS)"
```
### Code
```bash
format_time() {
  local ET h m s
  ET="$1"
  ((h=ET/3600))
  ((m=(ET%3600)/60))
  ((s=ET%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}
```
### Notes
