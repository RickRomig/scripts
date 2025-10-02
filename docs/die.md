# die
### Purpose
Display an error message and exits with an error code.
### Arguments
- $1 -> Error message
- $2 -> Exit status (optional, defaults to 1)
### Usage
```bash
command -x || die "Invalid option" 2
ERROR: Invalid option
```
### Code
```bash
die() {
  local -r errmsg="${1:-Undefined error}"
  local -r errcode="${2:-1}"
  printf "\e[91mERROR:\e[0m %s\n" "$errmsg" >&2
  exit "$errcode"
}
```
