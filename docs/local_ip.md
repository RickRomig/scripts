# local_ip
### Purpose
Extracts the last octet of the local IP address and assigns to a variable.
### Arguments
None
### Returns
Passes last octet of the local IP address to a variable.
### Usage
```bash
localip=$(local_ip)
echo "Local IP address: $localnet.$(local_ip)"
```
### Code
```bash
local_ip() {
  local octet
  octet=$(ip route get 1.2.3.4 | awk '{print $7}' | cut -d'.' -f4)
  [[ "$octet" ]] || die "No IP address found. Check network status." 1
  printf "%s" "$octet"
}
```
### Notes
