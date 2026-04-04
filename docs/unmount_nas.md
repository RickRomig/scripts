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
### Notes
- Removes `$tmp_dir` or `$tmp_file` if they exist.
- $tmp_dir, $tmp_file must be global variables in the calling script.
- Function should be called by the `trap` command to run whenever the calling script exits.
