# unmount\_server

1. **Purpose:** Unmount the SSHFS share created/mounted by `mount\_server`.

2. **Notes:**
   
   - Also removes `$TEMP_DIR` if it exists.
   
   - Function should be called by the `trap` command to run whenever the calling script exits for whatever reason.

```bash
unmount_server() {
  local SHARE="HP-6005"
  MOUNTED=$(mount | grep "$SHARE")
  [ -n "$MOUNTED" ] && fusermount -u "/mnt/$SHARE"
  [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
}
```


