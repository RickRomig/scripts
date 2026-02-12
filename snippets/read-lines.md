# Read lines
```bash
#!/bin/bash

LineCount=0

while IFS='' read -r LinefromFile || [[ -n "${LinefromFile}" ]]; do
  ((LineCount++))
  echo "Reading line $LineCount: ${LinefromFile}"
done < "$1"
# The [[ -n "${LinefromFile}" ]] clause caters for the possibility that the last
# line in the file doesn’t end with a carriage return. Even if it doesn’t, that
# last line will be handled correctly and treated as a regular POSIX-compliant line.
```
## Flush keyboard buffer
```bash
while true; do
  read -rs -d '' -N 1 -t 0.2    # -s = do not echo input coming from the terminal
  [[ "$?" -gt 128 ]] && break   # if error code > 128, time out with no input
done

flush_kb_buffer() {
  # from BU script
	while read -r -N 1 -t 0.01
	do :
	done
}

```
