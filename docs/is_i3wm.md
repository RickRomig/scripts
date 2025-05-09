# is_i3wm
### Purpose
Check if the window manager is i3wm.
### Arguments
None
### Returns
TRUE (0) is the window manager is i3wm, otherwise returns FALSE (1).
### Usage
```bash
is_i3wm && do something
```
### Code
```bash
is_i3wm() {
  # [[ $(wmctrl -m | awk '/Name/ {print $2}') == "i3" ]] && return "$TRUE" || return "$FALSE"
  [[ -f /usr/bin/i3-session ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
