# get_distribution
### Purpose
Display the full name of the installed Linux distribution.
### Arguments
None
### Returns
Passes distribution name to a variable using command substitution.
### Usage
```bash
echo "Distribution is $(get_distribution)"
Linux Mint 22.1 Xia
```
### Code
```bash
get_distribution() {
  local distro
  if [[ -f /etc/lsb-release ]]; then
    distro=$(awk -F= '/DISTRIB_DESCRIPTION/ {print $NF}' /etc/lsb-release | sed 's/"//g')
  else
    distro=$(/usr/bin/lsb_release --description --short)
  fi
  echo "$distro"
}
```
### Notes
In many Debian-based distributions the file `/etc/lsb-release` does not exist, so the function will obtain the distribution name from the `lsb_release` command.
