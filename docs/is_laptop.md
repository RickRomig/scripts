# is_laptop
### Purpose
Check if the system is a laptop.
### Arguments
None
### Returns
TRUE (0) is the system is a laptop, otherwise returns FALSE (1).
### Usage
```bash
is_laptop && do something
```
### Code
```bash
is_laptop() {
  [[ -d /proc/acpi/button/lid/ ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
