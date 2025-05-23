# Get interface name
```bash
$ ip ad show | awk '/: en/ {print $2}' | sed 's/:$//'
$ ip ad show | awk '/: wl/ {print $2}' | sed 's/:$//'
$ ip ad show | awk '/: vir/ {print $2}' | sed 's/:$//'
$ ip ad show | awk '/: vir/ {print $2;exit}' | sed 's/:$//'

$ eth_int=$(sudo /usr/bin/lshw -class network | awk '/name: en/ {print $NF}')
$ wifi_int=$(sudo /usr/bin/lshw -class network | awk '/name: wl/ {print $NF}')

$ /usr/bin/nmcli dev | awk '/ethernet/ {print $1}'
$ /usr/bin/nmcli dev | awk '/wifi/ {print $1}'

$ grep -r '.*' /sys/class/net/*/device/vendor
/sys/class/net/enp0s31f6/device/vendor:0x8086
/sys/class/net/wlp2s0/device/vendor:0x8086
```
#### Device state:
```bash
$ cat /sys/class/net/<dev>/operstate
states:
	up
	down
	unknown
```
#### SSID and Signal level:
```bash
$ /sbin/iwconfig | grep 'ESSID' | cut -d: -f2 | sed 's/"//g'	# Requires sudo on #23
$ /sbin/iwconfig | grep 'Signal' | cut -d= -f3 	# Requires sudo on #23

$ /sbin/iwconfig | awk -F: '/ESSID/ {print $2}' | sed 's/"//g'	# Requires sudo on #23
$ /sbin/iwconfig | awk -F= '/Signal/ {print $3}' # Requires sudo on #23

# Method finally used in ip-info
$ /sbin/iw dev <interface> link | awk '/SSID/ {print $2}'	# Requires sudo on #23
$ /sbin/iw dev <interface> link | awk '/signal/ {print $2,$3}'	# Requires sudo on #23

$ /sbin/iwgetid -r 	# SSID  does not exist on #19

$ awk '/wl/ {print $4 " dBm"}' /proc/net/wireless | sed 's/\.//'	# Signal, requires sudo on #23

$ /usr/bin/nmcli dev show <interface> | awk '/GENERAL.CONNECTION/ {print $NF}'	# 12 shows Wireless Connection 1 not SSID
```
#### DNS nameservers:
```bash
$ resolvectl status | grep -1 'DNS Server'
    DNSSEC supported: no
  Current DNS Server: 208.67.222.222
         DNS Servers: 84.200.69.80
                      84.200.70.40

$ /usr/bin/nmcli dev show | awk '/IP4.DNS/ {print $NF}' | sort -u
```
#### Find available wireless networks:
```bash
$ nmcli -f SSID,SECURITY,SIGNAL,BARS dev wifi | sed '/SSID/d;/^--/d'
```
#### Connect to a wireless network from the command line:
```bash
$ sudo nmcli d wifi connect "$ssid_name" password "$passphrase" ifname "$wifi_dev"
```
#### Bring up a network interface
```bash
sudo ip link set interface-name up
sudo ip link set interface-name down
```
#### Get local network address
Assumes a /24 (Class C) private network.
```bash
ip route get 1.2.3.4 | cut -d' ' -f3 | sed 's/\..$//'
ip route get 1.2.3.4 | awk '{print $3}' | cut -d '.' -f1,2,3
ip route | awk '/default via/ {print $3}' | sort -u | cut -d'.' -f1,2,3
```
