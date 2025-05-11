# mount_server
### Purpose
Mount a specific remote server on the local network using sshfs.
### Arguments
None
### Returns
None
### Usage
```bash
mount_server
```
### Code
```bash
mount_server() {
  local server_ip share mounted
  server_ip="11"
  share="HP-6005"
  ping -c3 "$LOCALNET.$server_ip" > /dev/null 2>&1 || die "$share at $LOCALNET.$server_ip is not online."
  if [[ -d "$HOME/mnt/$share/" ]]; then
    mounted=$(mount | grep "$share")
    if [[ -z "$mounted" ]]; then
      sshfs -o follow_symlinks rick@"$LOCALNET.$server_ip:/home/rick" "$HOME/mnt/$share/"
      echo "$share has been mounted."
    else
      echo "$share is already mounted"
    fi
  else
    # Create the mount point.
    mkdir -p "$HOME/mnt/$share/"
    sshfs -o follow_symlinks rick@"$LOCALNET.$server_ip:/home/rick" "$HOME/mnt/$share/"
    echo "$share has been created and mounted."
  fi
}
```
### Notes
- Checks to see if the server is accessible on the network.
- The mount point will be created if it does not already exist.

