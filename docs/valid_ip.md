# valid_ip
### Purpose
Check if a passed IP address is valid on the local network.
### Arguments
$1 -> last octet of the IP address to be validated.
### Returns
0 if the address is valid and reachable, otherwise returns an error code.
### Usage
```bash
validip "$1" && ssh "$LOCALNET.$1"
```
### Notes
- Takes as input the last octet of an IP address on the local network.
- Assumes a Class C /24 network, last octet between 1 and 254.
- Returns 0 if the argument is a valid and reachable IP address.

