# die
### Purpose
Display an error message and exits with an error code.
### Arguments
- $1 -> Error message
- $2 -> Exit status (optional, defaults to 1)
### Usage
```bash
command -x || die "invalid option" 2
```
### Code
```bash
die() {
  local errmsg errcode
  errmsg="${1:-Undefined error}"
  errcode="${2:-1}"
  printf "\e[91mERROR:\e[0m %s\n" "$errmsg" >&2
  exit "$errcode"
}
```
