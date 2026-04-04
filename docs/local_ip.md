# local_ip
### Purpose
Extract the last octet of the local IP address and assigns to a variable.
### Arguments
None
### Returns
Passes last octet of the local IP address to a variable.
### Usage
```bash
localip=$(local_ip)
echo "Local IP address: $LOCALNET.$localip" # or
echo "Local IP address: $LOCALNET.$(local_ip)"
```
### Notes
