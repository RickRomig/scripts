# is_nobel
### Purpose
Check if a distribution is based on Ubuntu 24.04 (Noble Numbat), such as Linux Mint 22.x.
### Arguments
None
### Returns
TRUE (0) is the distriibution is Ubuntu 24.04 or based on it, otherwise returns FALSE (1).
### Usage
```bash
is_noble && do something
```
### Code
```bash
is_noble() {
  [[ $(awk -F= '/UBUNTU_CODENAME/ {print $NF}' /etc/os-release) == "noble" ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
