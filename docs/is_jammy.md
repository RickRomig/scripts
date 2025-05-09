# is_jammy
### Purpose
Check if a distribution is based on Ubuntu 22.04 (Jammy Jellyfish), such as Linux Mint 21
### Arguments
None
### Returns
TRUE (0) is the distriibution is Ubuntu 22.04 or based on it, otherwise returns FALSE (1).
### Usage
```bash
is_jammy && do something
```
### Code
```bash
is_jammy() {
  [[ $(awk -F= '/UBUNTU_CODENAME/ {print $NF}' /etc/os-release) == "jammy" ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
