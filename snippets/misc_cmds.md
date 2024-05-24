# Miscellaneous Commands

#### Command priorty
1. alias
2. function
3. bash builtin
4. command
#### hostenamectl - hostname
```bash
$ hostnamectl | grep 'hostname' | cut -d':' -f2 | sed 's/^ //'
$ hostnamectl | grep 'hostname' | cut -d' ' -f6
```
#### hostenamectl - Operating System:
```bash
$ hostnamectl | grep 'System' | cut -d':' -f2 | sed 's/^ //'
$ hostnamectl | grep 'System' | cut -d' '  -f5-
```
#### hostenamectl - Kernel version:
```bash
$ hostnamectl | grep 'Kernel' | cut -d':' -f2 | sed 's/^ //'
$ hostnamectl | grep 'Kernel' | cut -d' ' -f14-
```
#### Assign Hostname to a variable
```bash
$ host="${HOSTNAME:-$(hostname)}"
```

#### Add a user
- `adduser` - A frontend for `useradd` that sets up a user with basic attributes. Prompt for info.
- `useradd` - Low level utility that creates a user. Needs additional flags to set up attributes.
```bash
$ sudo useradd -s /bin/bash -m -c "First Last,Room Nr,Phone," username
$ sudo vipw   # edit /etc/passwd to edit Gecos information - Full name, Room, phone, other
$ sudo adduser username
$ sudo useradd -d /home/username -s /bin/bash -c Fullname,RoomNr,Phone,Other username && passwd username
```

#### Gecos info from /etc/passwd
```bash
gecos=$(awk -F: '/rick/ {print $5}' /etc/passwd)
name=$(echo "$gecos" | cut -d',' -f1)
room=$(echo "$gecos" | cut -d',' -f2)
phone=$(echo "$gecos" | cut -d',' -f3)
```

#### Change a user's default shell
```bash
sudo usermod --shell /bin/bash <user>
sudo usermod -s /bin/bash <user>
sudo chsh --shell  /bin/bash <user>
sudo chsh -s /bin/bash <user>
```

#### ps command to find init system
- From the command line:
  ```bash
  ps -p 1 | awk '/1 ?/ {print $4}'	# Returns either systemd or init
  ps -p 1 | awk '/1 ?/ {print $NF}'	# Returns either systemd or init
  ```
- As a function:
  ```bash
  check_init() {
    echo -n "Initialization system is "
    INIT_SYS=$(ps -p 1 | awk '/1 ?/ {print $4}')
    case $INIT_SYS in
      "systemd" ) echo "systemd" ;;
      "init" ) echo "SysV or other non-systemd" ;;
      * ) echo "an undetermined init system" ;;
   esac
  }
  ```
#### check for systemd, sysvinit or upstart
```bash
$ cat /sbin/init | awk 'match($0, /(upstart|systemd|sysvinit)/) { print toupper(substr($0, RSTART, RLENGTH));exit; }' 2> /dev/null
$ if [[ -r /proc/1/comm ]]; then read -r data < '/proc/1/comm';printf "%s\n" "${data%% *}";else printf '?\n';fi
```
#### Fix missing panel in Cinnamon
```bash
$ dconf reset -f /    # forces reset of all settings to defaults
# /usr/share/cinnamon/cinnamon-settings/cinnamon-settngs.py panel
```
#### nmcli - active connections
```bash
$ nmcli -p con show | awk '/ethernet/ {print $NF}'
$ nmcli -p con show | awk '/wifi/ {print $NF}'
$ nmcli -p con show | awk '/bridge/ {print $NF}'
```
#### die function
```bash
die() { exec 2>&1 ; for line ; do echo "$line" ; done ; exit 1 ; }

die() {
	exec 2>&1
	for line; do
		echo "$line"
	done
	exit 1
}
```
#### Run a script on a remote host
```bash
$ ssh rick@192.168.0.100 'bash -s' < local.sh
```
#### Run a script on a remote host with arguments
`$ ssh rick@192.168.0.100 'bash -s' -- < local2.sh arg1 arg2 arg3 ...`

#### Run a section of a script (heredoc) on a remote host
```bash
#!/bin/bash

# local processing can done here

# remote processing is done here
ssh -T rick@192.168.0.100 << _remote_commands

# commands to be run remotely would be added here
cd /home/rick/Documents
# etc.

# Finally, update the timestamp file
echo "Script3.sh:" $(date) >> /home/rick/timestamp.txt

# this is the label that marks the end of the redirection
_remote_commands

# more local processing can be done here

exit 0

$ ./local3.sh
```

#### Brave/Chrome/Firefox versions
```bash
$ brave-browser --version | awk '{print $NF}'
$ brave-browser --version | cut -d' ' -f3
$ dpkg -l | awk '$2 == "brave-browser" {print $3}'	# leaves off first xxx.
$ google-chrome-stable --version | awk '{print $NF}'
$ google-chrome-stable --version | cut -d' ' -f3
$ dpkg -l | awk '$2 == "google-chrome-stable" {print $3}' | sed 's/[+-].*//'
$ firefox --version | awk '{print $NF}'
$ firefox --version | cut -d' ' -f3
$ dpkg -l | awk '$2 == "firefox" {print $3}' | sed 's/[+-].*//'
```
#### Clear screen on script exit.
```bash
$ trap 'printf \\e[2J\\e[H\\e[m' EXIT
```
#### Disable Crtl+C
```bash
trap '' 2
commands
trap 2; exit
```

#### tar
```bash
$ tar -zcf /path/to/archive.tar.gz -C "$HOME"/ <src_directory>
$ tar -xzvf /path/to/archive.tar.gz # uncompresses to $PWD
```

#### Check multiple batteries on a laptop
```bash
for battery_path in /sys/class/power_supply/BAT?; do
  if [[ "$battery_path" != "/sys/class/power_supply/BAT?" ]]; then
    echo $'\n'$"${orange}Battery:${normal} $(basename "$battery_path")"
    battery_status
    battery_capacity
  else
    echo $'\n'$"${lightred}No battery detected.${normal}" >&2
  fi
done
```
#### Find a mountable drive:
```bash
$ lsblk -lp | grep "part $" | awk '{print $1, "(" $4 ")"}'
$ lsblk -lp |  awk '/part $/ {print $1, "(" $4 ")"}'
```
#### Combine find and grep to search for files containing a specific pattern:
```bash
find /path/to/search -type f -exec grep -H 'pattern' {} +
find /path/to/search -type f -exec grep -n 'pattern' {} +
find /path/to/search -maxdepth 1 -type f -exec grep -n 'pattern' {} +
```
`grep -H` prints the file name for each match. This is the default when there is more than one file to search. (a GNU extension)

#### Combine ps aux with grep to find running processes by name:
```bash
ps aux | grep php
```
#### Status of updates
```bash
zgrep -h "status installed Package-name" /var/log/dpkg.log* | sort | tail -n 1
```
#### Last terminal line off screen workaround
In .bashrc, add `\n\n\[\033[2A\]` to the beginning of the PS1 prompt. This will move down 2 lines, then back up 2 lines before displaying the prompt.
Adjust by adding or deleting newlines and changing the number before the `A`.

#### Check if caps lock is on
```bash
xset -q | grep 'Caps Lock:   on' && echo "Caps Lock on."
```
#### Display screen resolution
```bash
resolution="$(xrandr | grep '*' | head -n 1 | awk '{print $1}')"
refresh_rate="$(xrandr | grep '*' | head -n 1 | awk '{print $2}' | sed 's/*+//')"
width="$(xrandr | grep '*' | head -n 1 | awk '{print $1}' | cut -d\x -f1)"
height="$(xrandr | grep '*' | head -n 1 | awk '{print $1}' | cut -d\x -f2)"
```
#### grep tricks
```bash
grep -v ^\# filename | grep .   # ignore commented and blank lines
grep -A 4 term    # display 4 lines after the matched term
grep -B 2 term    # display 2 lines before the matched term
grep -C 2 term    # display 2 lines befor and after the matched term
grep -c term      # display the number of matches
grep -n term      # display the line number of each match
grep -r term      # search recursively
```
### Last reboot
```bash
$ last reboot | head -1
reboot   system boot  5.15.0-107-gener Tue May 14 11:18   still running
$ who -b
         system boot  2024-05-14 11:18
$ uptime -s
2024-05-14 11:17:58
$ journalctl --list-boots | tail -1
0 0ea13566e91843ae979c01341daedf93 Tue 2024-05-14 11:18:03 EDT—Fri 2024-05-17 10:54:08 EDT
$ journalctl -b <boot_id> # 1st field from --list-boots
# produces hundreds of lines of information
```
