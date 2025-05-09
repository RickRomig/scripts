# is_xfce
### Purpose
Check if the desktop environment is XFCE.
### Arguments
None
### Returns
TRUE (0) is the window manager is XFCE, otherwise returns FALSE (1).
### Usage
```bash
is_xfce && do something
```
### Code
```bash
is_xfce() {
  [[ -f /usr/bin/xfce-session ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
