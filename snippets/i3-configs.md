# i3wm Configuration Information

## Basic information

#### i3 Version

  ```bash
  $ i3 -v | awk '{print $3}' | sed 's/-.*//'
  $ i3 -v | cut -d' ' -f3  | sed 's/-.*//'
  ```

#### Location

  ```bash
  $ which i3
  /usr/local/bin/i3
  ```

#### Workspaces
- Keybindings
  super+shift+b
    i3-msg move container to workspace back_and_forth
  super + shift + b
    i3-msg move workspace to output next
  Move focused workspaces between monitors
  super+ctrl+greater
    i3-msg move workspace to output right
  super+ctrl+less
    i3-msg move workspace to output left


## Scratchpads & Floating Windows

### Window sizes based on screen resolution

| Resolution | 1920x1080 | 1680x1050 | 1440x900 | 1366x768 | 1280x800 | 1024x600 |
| ---------- | --------- | --------- | -------- | -------- | -------- | -------- |
| 90%        | 1728 972  | 1512 945  | 1296 810 | 1229 691 | 1152 720 | 922 540  |
| 80%        | 1536 864  | 1344 840  | 1152 720 | 1093 614 | 1024 640 | 819 480  |
| 75%        | 1440 810  | 1260 788  | 1080 675 | 1025 576 | 960 600  | 768 450  |
| 60%        | 1152 648  | 1008 630  | 864 540  | 820 461  | 768 480  | 614 360  |
| 50%        | 960 540   | 840 525   | 720 450  | 683 384  | 640 400  | 512 300  |
| 40%        | 768 432   | 672 420   | 576 360  | 546 307  | 512 320  | 410 240  |
| 30%        | 576 324   | 504 315   | 432 270  | 410 230  | 384 200  | 307 180  |
| 25%        | 480 270   | 420 263   | 360 225  | 342 192  | 320 200  | 256 150  |

## Miscellaneous

### dmenu scripts

#### Multiple montiors
**Toggle on/off external monitor**
`extramonitor`
```bash
#!/usr/bin/env bash
# Toggle on/off an external monitor (# 13 probook-6570b)

intern="LDVS-1"
extern="VGA-1"

# xrandr outupt LVDS-1 --primary --mode 1366x768 --pos 0+0 --rotate normal --output VGA-1 --mode 1440x900 --pos 1366+0 --rotate normal

case "$1" in
    "disconnect") xrandr --output "$extern" --off --output "$intern" --auto ;;
    "extra") xrandr --output "$extern" --mode 1440x900 && xrandr --output "$intern" --auto --output "$extern" --right-of "$intern" ;;
    "duplicate") xrandr --output "$extern" --mode 1440x900 && xrandr --output "$intern" --auto --output "$extern" --same-as "$intern" ;;
esac
```
** dmenu script to call extramonitor**
super+x or super+z or super+shift+x
  ~/.conffig/i3/multimonitor
`multimonitor`
```bash
#!/usr/bin/env bash
echo -e "disconnect\nextra\nduplciate" | dmenu -i -p "Monitor configuration" | xargs -I % ~/.config/i3/extramonitor "%"
```
**Prompt to quit i3**
super+shift+q
  ~/config/i3/prompt
`prompt`
```bash
#/usr/bin/env sh
if [ $(echo -e "No\nYes" | dmenu -i -p "$1") == "Yes" ]; then $2; fi
prompt "Are you sure you would like to quit this Xsession" "i3-msg exit"
```

- autostart.sh (LinuxTechGeek i3 autostart.sh)

```bash
#!/usr/bin/env sh
~/.config/polybar/launch.sh &
nitrogen --restore &
picom --experimental-backends --backend glx --xrender-sync-fence --vsync &
# sxhkd
sxhkd -c $HOME/.config/sxhkd/sxhkd-i3 &
```

- picom configuration (rounded corners)

  ```bash
  ~/.config/picom.conf
  corner-radius = 10;
  round-borders = 1;
  ~/.config/i3/config
  default_border pixel 4
  # to dynamically adjust border size of all existing windows
  i3-msg [class=.*] border pixel 1
  # or whatever number desired.
  ```

- Polybar

  - [Polybar]([GitHub - polybar/polybar: A fast and easy-to-use status bar](https://github.com/polybar/polybar))

  - [Fontawesome icons]([Icons Icon | Font Awesome](https://fontawesome.com/v6/icons/))

  - `$ fc-list | grep -i awesome`