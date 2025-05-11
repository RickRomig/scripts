# root_user
### Purpose
Check if a script is being run by the root user.
### Arguments
None
### Returns
TRUE (0) or FAALE (1)
### Usage
```bash
root_user || die "User must be root." 1
```
### Code
```bash
root_user() {
  [[ "$(id -u)" -eq "0" ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
