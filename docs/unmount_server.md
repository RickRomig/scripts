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
### Notes
- Removes `$tmp_dir` or `$tmp_file` if they exist.
- $tmp_dir, $tmp_file must be global variables in the calling script.
- Function should be called by the `trap` command to run whenever the calling script exits.
