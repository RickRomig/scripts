# Extract IP4 addresses from files
```bash
$ grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' ufw.log
$ grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' ufw.log
```
#### IP data
```bash
$ ip_data=$(ip route get 1.2.3.4 | awk '/via/ {print $0}')
$ local_net=$(echo "$ip_data" | awk '{print $3}' | cut -d'.' -f1,2,3)
$ local_addr=$(echo "$ip_data" | awk '{print $7}')
$ local_ip=$(echo "$ip_data" | awk '{print $7}' | cut -d'.' -f4)
$ local_gateway=$(echo "$ip_data" | awk '{print $3}')
```
#### Obtain local network:
```bash
$ localnet=$(ip route get 1.2.3.4 | awk '{print $3}' | cut -d '.' -f1,2,3 ) # or print $7
$ localnet=$(ip route | awk '/default via/ {print $3}' | sort -u | cut -d'.' -f1,2,3)
```
#### Obtaining local IP address:
```bash
$ hostname -I
$ ip -4 a | awk '/inet / {print $2}' | grep -v "127.0.0.1" | cut -d\/ -f1
$ ip -4 a | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1'
$ ip route show | awk '/src/ {print $9}'
$ ip route get 1.2.3.4 | awk '{print $7}' # preferred method (can print $3)
```
#### Extract last octet from local IP address
```bash
$ ip route show | awk '/link src/ {print $9}' | cut -d'.' -f4
$ ip route get 1.2.3.4 | awk '{print $7}' | cut -d'.' -f4
```
**Original method in functionlib**
```bash
local_ip() {
  en_ip=$(/usr/bin/ip route show | awk '/en/ && /link src/ {print $9}')
  wl_ip=$(/usr/bin/ip route show | awk '/wl/ && /link src/ {print $9}')
  et_ip=$(/usr/bin/ip route show | awk '/eth/ && /link src/ {print $9}')

  if [[ -n "$en_ip" ]]; then
    octet="${en_ip##*.}"
  elif [[ -n "$et_ip" ]]; then
    octet="${et_ip##*.}"
  elif [[ -n "$wl_ip" ]]; then
    octet="${wl_ip##*.}"
  else
    die "No IP address found. Check network status." 1
  fi
  printf "%s" "$octet"
}
```
**Revised method in functionlib**
```bash
local_ip() {
  en_ip=$(/usr/bin/ip route show | awk '/en/ && /link src/ {print $9}' | cut -d'.' -f4)
  wl_ip=$(/usr/bin/ip route show | awk '/wl/ && /link src/ {print $9}' | cut -d'.' -f4)
  et_ip=$(/usr/bin/ip route show | awk '/eth/ && /link src/ {print $9}' | cut -d'.' -f4)

  if [[ -n "$en_ip" ]]; then
    octet="$en_ip"
  elif [[ -n "$et_ip" ]]; then
    octet="$et_ip"
  elif [[ -n "$wl_ip" ]]; then
    octet="$wl_ip"
  else
    die "No IP address found. Check network status." 1
  fi
  printf "%s" "$octet"
}
```
#### Extract DNS addresses from /etc/NetworkManager/system-connections/
```bash
$ sudo awk -F= '/dns=/ {print $2}' /etc/NetworkManager/system-connections/'Wired connection 1.nmconnection' | sed 's|;|\n|g'
84.200.69.80
84.200.70.40
208.67.222.222
$ dns_svr=$(sudo awk -F= '/dns=/ {print $2}' /etc/NetworkManager/system-connections/'Wired connection 1.nmconnection')
$ echo -e "\t$dns_svr" | sed 's| |\n\t|g'
# 'Wired connection 1' for hp-800-g1-dm (19) and hp-2560p (23)
```
#### Extract DNS addresses from /etc/network/interfaces
```bash
$ grep 'dns-nameservers' /etc/network/interfaces | cut -d' ' -f2- | sed 's| |\n|g'
84.200.69.80
84.200.70.40
$ dns_svr=$(grep 'dns-nameservers' /etc/network/interfaces | cut -d' ' -f2-)
$ echo -e "\t$dns_svr" | sed 's| |\n\t|g'
84.200.69.80
84.200.70.40
```