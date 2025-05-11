# user_exists
### Purpose
Checks if the user passed to the function exists in `/etc/passwd`.
### Arguments
Username to check in `/etc/passwd`
### Returns
TRUE (0) or FALSE (1)
### Usage
```bash
user_exists Bob
```
### Code
```bash
user_exists() {
  local U="$1"
  grep -q "^${U}" /etc/passwd && return "$TRUE" || return "$FALSE"
```
### Notes
