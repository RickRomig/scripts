# format_time
### Purpose
Display the elasped time for the running of a script
### Arguments
$1 -> $SECONDS  # environmental variable
### Usage
```bash
SECONDS=0
# Contents of the script...
echo "Script completed in $(format_time $SECONDS)"
```
### Notes
