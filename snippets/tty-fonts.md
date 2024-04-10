# Changing tty fonts
### On Debian Mint, MX systems
`/usr/share/consolefonts`
### To change fonts in a tty:
```bash
setfont /usr/share/consolefonts/Lat15-Terminus32x16.psf.gz
# Persistent font change, edit /etc/default/console set-up
# Add FONT="TTY-FONT-NAME" after FONTSIZE
```
### CONFIGURATION FILE FOR SETUPCON
Consult the console-setup(5) manual page.
```bah
ACTIVE_CONSOLES="/dev/tty[1-6]"

CHARMAP="UTF-8"

CODESET="guess"
FONTFACE="Fixed"
FONTSIZE="8x16"

VIDEOMODE=
```
The following is an example how to use a braille font
```bash
FONT='lat9w-08.psf.gz brl-8x8.psf'
```
