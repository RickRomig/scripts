# is_arch
### Purpose
Check if the distribution is based on Arch Linux.
### Arguments
None
### Returns
TRUE or FALSE (0 or 1)
### Usage
```bash
is_arch && pacman -S
```
### Code
```bash
is_arch() {
  [[ -d /etc/pacman.d ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
