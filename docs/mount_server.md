# mount_server
### Purpose
Mounts a specific sshfs server on the local network using `sshfs` in user's home directory.
### Arguments
None
### Returns
None
### Usage
```bash
mount_server
```
### Notes
- Checks to see if the server is accessible on the network.
- The mount point will be created if it does not already exist.
- `$tmp_dir` or `$tmp_file` must be declared as global variables in the calling script.

