# get_distribution
### Purpose
Display the full name of the installed Linux distribution.
### Arguments
None
### Returns
Ddistribution name is passed to a variable using command substitution.
### Usage
```bash
echo "Distribution is $(get_distribution)"
Linux Mint 22.1 Xia
```
### Notes
In some Debian-based distributions the file `/etc/lsb-release` may not exist, so the function will obtain the distribution name from the `lsb_release` command.
