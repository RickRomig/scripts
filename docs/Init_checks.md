# Init checks
### Purpose
Check what initialization system is in use
### Arguments
None
### Returns
TRUE or FALSE (0 or 1)
### Usage
```bash
is_systemd && do something
is_sysv && do something
is_openrc && do something
is_runit && do something
```
### Code
1. Systemd
```bash
is_systemd() {
  [[ $(cat /proc/1/comm) == "systemd" ]] && return "$TRUE" || return "$FALSE"
}
```
2. SysV
```bash
is_sysv() {
  [[ $(/sbin/init --version 2>/dev/null | awk '{print $1}') == "SysV" ]] && return "$TRUE" || return "$FALSE"
}
```
3. OpenRC
```bash
is_openrc() {
  [[ -f /sbin/openrc ]] && return "$TRUE" || return "$FALSE"
}
```
4. Runit
```bash
is_runit() {
  [[ $(cat /proc/1/comm) == "runit" ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
Other checks:
```bash
strings /sbin/init | grep -q "/lib/systemd" && echo SYSTEMD
strings /sbin/init | grep -q "sysvinit" && echo SYSVINIT
strings /sbin/init | grep -q "upstart" && echo UPSTART
```
