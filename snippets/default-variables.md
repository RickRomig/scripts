# Setting default variables

#### Command line arguments:
```bash
var1="${1:-default_value}"
var2="${2:-default_value}"
```
#### within a script
```bash
var1=$(awk '/value/ {print $NF}')
var="${var1:-default_value}"
```