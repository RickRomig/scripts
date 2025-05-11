# unmount_server
### Purpose
Unmount the SSHFS share created/mounted by `mount_server`.
### Arguments
None
### Returns
Mothng
### Usage
```bash
unmount_server
```
### Code
```bash
# shellcheck disable=SC2154
unmount_server() {
  local mounted share
  share="HP-6005"
  mounted=$(mount | grep "$share")
  if [[ -n "$mounted" ]]; then
    fusermount -u "$HOME/mnt/$share"
    [[ -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
    [[ -f "$tmp_file" ]] && rm -f "$tmp_file"
    printf "%s has been unmounted.\n" "$share"
  else
    printf "%s is not mounted.\n" "$share" >&2
  fi
}
```
### Notes
- Removes `$tmp_dir` or `$tmp_file` if they exist.
- Function should be called by the `trap` command to run whenever the calling script exits.
