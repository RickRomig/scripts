# Desktop Environment and Window Manger information
#### Desktop environment:
```bash
$ echo $DESKTOP_SESSION
```
#### Window Manager:
```bash
$ wmctrl -m | grep -w Name | cut -d' ' -f2-
```