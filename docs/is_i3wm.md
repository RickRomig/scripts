# is_i3wm
### Purpose
Check if the window manager is i3wm.
### Arguments
None
### Returns
TRUE (0) is the window manager is i3wm, otherwise returns FALSE (1).
### Usage
```bash
is_i3wm && do_something
```
### Notes
`wmctrl` does not work with an SSH connection.