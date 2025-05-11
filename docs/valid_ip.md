# valid_ip
### Purpose
Check if a passed IP address is valid on the local network.
### Arguments
The last octet of an IP address on the local network.
### Returns
0 if the address is valid and reachable, otherwise exits with an error code.
### Usage
```bash
validip "$1" && ssh "$LOCALNET.$1"
```
### Code
```bash
valid_ip() {
  local octet status localip
  octet="$1"
  status=0
  localip="$(local_ip)"
  if [[ -z "$octet" ]]; then
    status=1
    printf "%s No argument passed. No host IP.\nEnter the last octet of the target IP address (1 - 254).\n" "$RED_ERROR" >&2
  elif [[ "$1" =~ ^[0-9]+$ ]] 2>/dev/null; then
    # Argument is an integer value
    if (( octet > 0 )) && (( octet < 255 )); then
      # Valid address - test if reachable or local machine
      if [[ "$localip" -eq "$octet" ]]; then
        status=2
        printf "%s %s.%s is the local client computer.\n" "$RED_ERROR" "$LOCALNET" "$octet" >&2
      elif ping -c 1 "$LOCALNET.$octet" > /dev/null 2>&1; then
        status=0
        printf "%s.%s is a valid and reachable IP address.\n" "$LOCALNET" "$octet"
      else
        status=3
        printf "%s %s.%s is valid IP address but is unreachable.\nCheck to see if it is on the network.\n" "$RED_ERROR" "$LOCALNET" "$octet" >&2
      fi
    else
      status=4
      printf "%s %s.%s is not a valid IP address.\nEnter the last octet of the target IP address (1 - 254).\n" "$RED_ERROR" "$LOCALNET" "$octet" >&2
    fi
  else
    status=5
    printf "%s Invalid argument: %s\nEnter the last octet of the target IP address (1 - 254).\n" "$RED_ERROR" "$octet" >&2
  fi

  (( status == 0 )) && return "$status" || exit "$status"
}
```
### Notes
- Takes as input the last octet of an IP address on the local network.
- Assumes a Class C /24 network, last octet between 1 and 254.
- Returns 0 if the argument is a valid and reachable IP address.
- Exits with exit code of 1 if the argument is empty string.
- Exits with exit code of 2 if the address is address of the client computer.
- Exits with exit code of 3 if the address is valid but unreachable.
- Exits with exit code of 4 if the argument is outside the range of valid IP addresses.
- Exits with exit code of 5 if the argument is not an integer value.

