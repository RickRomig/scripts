# mount_nas
### Purpose
Mount the Network Area Storage (NAS) server on the local network using `sshfs`.
### Arguments
None
### Returns
Nothing
### Usage
```bash
mount_nas
```
### Notes
- Checks to see if the server is accessible on the network.
- The mount point will be created if it does not already exist.
- `$tmp_dir` or `$tmp_file` must be declared as global variables in the calling script.
