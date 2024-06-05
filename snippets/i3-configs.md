# i3wm Configuration Information

## Basic information

- **i3 Version**
  
  ```bash
  $ i3 -v | awk '{print $3}' | sed 's/-.*//'
  $ i3 -v | cut -d' ' -f3  | sed 's/-.*//'
  ```

- **Location**
  
  ```bash
  $ which i3
  /usr/local/bin/i3
  ```

- foo bar



## Scratchpads & Floating Windows

### Window sizes based on screen resolution

| Resolution | 1920x1080 | 1440x900 | 1366x768 | 1280x800 | 1024x600 |
| ---------- | --------- | -------- | -------- | -------- | -------- |
| 90%        | 1728 972  | 1296 810 | 1229 691 | 1152 720 | 922 540  |
| 80%        | 1536 864  | 1152 720 | 1093 614 | 1024 640 | 819 480  |
| 75%        | 1440 810  | 1080 675 | 1025 576 | 960 600  | 768 450  |
| 60%        | 1152 648  | 864 540  | 820 461  | 768 480  | 614 360  |
| 50%        | 960 540   | 720 450  | 683 384  | 640 400  | 512 300  |
| 40%        | 768 432   | 576 360  | 546 307  | 512 320  | 410 240  |
| 30%        | 576 324   | 432 270  | 410 230  | 384 200  | 307 180  |
| 25%        | 480 270   | 360 225  | 342 192  | 320 200  | 256 150  |

### 

## Miscellaneous

- dmenu script - multipmonitor (super+x or super+z or super+shift+x)

```bash
#!/usr/bin/env bash
echo -e "disconnect\nextra\nduplciate" | dmenu -i -p "Monitor configuration" | xargs -I % extramonitor "%"
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