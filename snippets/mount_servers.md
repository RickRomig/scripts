# Mount Servers
## Mount Server
```bash
mount_server() {
  local -r server_ip="11"
  local -r share="HP-6005"
  ping -c3 "$LOCALNET.$server_ip" >/dev/null 2>&1 || die "$share at $LOCALNET.$server_ip is not online." "$E_NETWORK"
  if [[ -d "$HOME/mnt/$share/" ]]; then
    mounted=$(grep "$share" <(mount))
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
	return 0
}
```
## Unmount Server
```bash
# shellcheck disable=SC2154
# var is referenced but not assigned
unmount_server() {
  local mounted
  local -r share="HP-6005"
  mounted=$(grep "$share" < <(mount))
  if [[ -n "$mounted" ]]; then
    fusermount -u "$HOME/mnt/$share"
    [[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"  # should be declered as a global variable in the calling script
    [[ -f "$TMP_FILE" ]] && rm -f "$TMP_FILE" # should be declered as a global variable in the calling script
    printf "%s has been unmounted.\n" "$share"
  else
    printf "%s is not mounted.\n" "$share" >&2
  fi
	return 0
}
```
## Mount NAS
```bash
mount_nas() {
  local server_ip share mounted
  server_ip="4"
  share="NASD97167"
  ping -c3 "$LOCALNET.$server_ip" > /dev/null 2>&1 || die "$share at $LOCALNET.$server_ip is not online." "$E_NETWORK"
  if [[ -d "$HOME/mnt/$share/" ]]; then
    mounted=$(grep "$share" <(mount))
    if [[ -z "$mounted" ]]; then
      sshfs -o follow_symlinks rick@"$LOCALNET.$server_ip:" "$HOME/mnt/$share/"
      echo "$share has been mounted."
    else
      echo "$share is already mounted"
    fi
  else
    mkdir -p "$HOME/mnt/$share/"    # Create the mount point.
    sshfs -o follow_symlinks rick@"$LOCALNET.$server_ip:" "$HOME/mnt/$share/"
    echo "$share has been created and mounted."
  fi
	return 0
}
```
## Unmount NAS
```bash
unmount_nas() {
  local mounted share
  share="NASD97167"
  mounted=$(grep "$share" < <(mount))
  if [[ -n "$mounted" ]]; then
    fusermount -u "$HOME/mnt/$share"
    [[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"  # should be declered as a global variable in the calling script
    [[ -f "$TMP_FILE" ]] && rm -f "$TMP_FILE" # should be declered as a global variable in the calling script
    printf "%s has been unmounted.\n" "$share"
  else
    printf "%s is not mounted.\n" "$share" >&2
  fi
	return 0
}
```
