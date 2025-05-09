# bunsenlabs
### Purpose
Return true if the distribution is a version of a Bunsen Labs distribution.
### Arguments
None.
### Returns
True or False.
### Notes
Specifically checks for a Debian-based distribution from Bunsen Labs.The `is_debian` function will return true for this distribution as it is based on Debian.
### Code
```bash
bunsenlabs() {
  distro=$(/usr/bin/lsb_release -d | /usr/bin/awk '{print $2}')
  [ "$distro" = "BunsenLabs" ] && return "$TRUE" || return "$FALSE"
}
```
