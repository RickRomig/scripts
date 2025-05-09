# is_focal
### Purpose
Returns true if the distribution is based on Ubuntu 20.04 (Focal Fossa), i.e., Linux Mint 20.x.
### Arguments
None
### Returns
True or False
### Usage
```bash
is_focal && do something
```
### Code
```bash
is_focal() {
  [[ $(awk -F= '/UBUNTU_CODENAME/ {print $NF}' /etc/os-release) == "focal" ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
