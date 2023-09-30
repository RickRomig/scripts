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