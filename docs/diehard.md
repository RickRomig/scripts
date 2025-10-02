# diehard
### Purpose
Display a multi-line error message (1 or more lines) and exit with an error code of 1.
### Arguments
Lines to be displayed immediately following the call to the function.
### Usage
```bash
cat foobar.conf || diehard "File does not exist." "Please check your spelling."
ERROR: File does not exist.
Please check your spelling.
```
### Code
```bash
diehard() {
  local line
	printf "\e[91mERROR:\e[0m "
	exec 2>&1; for line; do printf "%s\n" "$line"; done; exit 1
}
```
