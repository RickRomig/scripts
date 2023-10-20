# Miscellaneous Commands

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

# Add a user
```bash
$ sudo useradd -s /bin/bash -m -c "First Last,Room Nr,Phone," username
$ sudo vipw   # edit /etc/passwd to edit Gecos information - Full name, Room, phone, other
```

#### Gecos info from /etc/passwd
```bash
gecos=$(awk -F: '/rick/ {print $5}' /etc/passwd)
name=$(echo "gecos" | cut -d',' -f1)
room=$(echo "gecos" | cut -d',' -f2)
phone=$(echo "gecos" | cut -d',' -f3)
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
$ google-chrome-stable --version | cut -d' ' -f3'
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