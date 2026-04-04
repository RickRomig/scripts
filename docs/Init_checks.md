# Init checks
### Purpose
Check what initialization system is in use
### Arguments
None
### Returns
TRUE or FALSE (0 or 1)
### Usage
```bash
is_systemd && do_something
is_sysv && do_something
is_openrc && do_something
is_runit && do_something
```
### Notes
Other checks:
```bash
strings /sbin/init | grep -q "/lib/systemd" && echo SYSTEMD
strings /sbin/init | grep -q "sysvinit" && echo SYSVINIT
strings /sbin/init | grep -q "upstart" && echo UPSTART
```
