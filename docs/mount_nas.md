# mount_nas
### Purpose
Mount the Network Area Storage server on the local network using sshfs.
### Arguments
None
### Returns
Nothing
### Usage
```bash
mount_nas
```
### Code
```bash
mount_nas() {
  local server_ip share mounted
  server_ip="4"
  share="NASD97167"
  ping -c3 "$LOCALNET.$server_ip" > /dev/null 2>&1 || die "$share at $LOCALNET.$server_ip is not online."
  if [[ -d "$HOME/mnt/$share/" ]]; then
    mounted=$(mount | grep "$share")
    if [[ -z "$mounted" ]]; then
      sshfs -o follow_symlinks rick@"$LOCALNET.$server_ip:" "$HOME/mnt/$share/"
      echo "$share has been mounted."
    else
      echo "$share is already mounted"
    fi
  else
    mkdir -p "%HOME/mnt/$share/"    # Create the mount point.
    sshfs -o follow_symlinks rick@"$LOCALNET.$server_ip:" "$HOME/mnt/$share/"
    echo "$share has been created and mounted."
  fi
}
```
### Notes
- Checks to see if the server is accessible on the network.
- The mount point will be created if it does not already exist.
