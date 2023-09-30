# Debian - disable suspend
Disable hibernation
[Suspend](https://wiki.debian.org/Suspend)
```bash
# Enable
$ sudo systemctl mask sleep.target suspend.target hibernation.target hybrid-sleep.target

# Re-enable:
$ sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
This is the preferred method for Buster and newer.

#### Create `/etc/systemd/sleep.conf.d/nosuspend.conf` as
```
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
```
Prevent suspending when the lid is closed you can set the following options in `/etc/systemd/logind.conf`:
```
[Login]
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
```
Then run `systemctl restart systemd-logind.service` or reboot.
