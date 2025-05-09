# is_cinnamon
### Purpose
Return TRUE if the active desktop environment is Cinnamon.
### Arguments
None
### Returns
TRUE or FALSE (0 or 1)
### Usage
```bash
is_cinnamon && do something
```
### Code
```bash
is_cinnamon() {
[ -f /usr/bin/cinnamon-session ] && return "$TRUE" || return "$FALSE"
}
```
### Notes
