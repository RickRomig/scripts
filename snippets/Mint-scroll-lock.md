# Enable Scroll Lock in Mint 21.X

```bash
$ sudo sed -i '82s|.*|modifier_map Mod3 { Scroll_Lock };|' /usr/share/X11/xkb/symbols/pc && sudo dpkg-reconfigure xkb-data
```
Useful for a large spreadsheet or image that's too large to fit on the screen.
Toggleed on and off with the `Scroll Lock` key.
A restart will be required to take affect.
