# Suspend-Hibernation

## Disable Suspend and Hibernation in Linux
1. To prevent your Linux system from suspending or going into hibernation, you need to disable the following systemd targets:
```bash
$ sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
hybrid-sleep.target
Created symlink /etc/systemd/system/sleep.target → /dev/null.
Created symlink /etc/systemd/system/suspend.target → /dev/null.
Created symlink /etc/systemd/system/hibernate.target → /dev/null.
Created symlink /etc/systemd/system/hybrid-sleep.target → /dev/null.
```
2. reboot the system and log in again, then verify if the changes have been effected using the command:
```bash
$ sudo systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
```
## Enable Suspend and Hibernation in Linux
1. To re-enable the suspend and hibernation modes, run the command:
```bash
$ sudo systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
```
## Prevent suspend when closing laptopt lid
1. To prevent the system from going into suspend state upon closing the lid, edit the /etc/systemd/logind.conf file.
```bash
$ sudo micro /etc/systemd/logind.conf
```
2. Append the following lines to the file.
```bash
[Login]
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
```
3. Save and exit the file. Be sure to reboot in order for the changes to take effect.
