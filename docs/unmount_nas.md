# unmount_nas
### Purpose
Unmount the SSHFS share on the NAS created/mounted by `mount_nas`.
### Arguments
None
### Returns
Nothing
### Usage
```bash
unmount_nas
```
### Code
```bash
# shellcheck disable=SC2154
unmount_nas() {
  local mounted share
  share="NASD97167"
  mounted=$(mount | grep "$share"); local mounted
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
