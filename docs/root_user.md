# root_user
### Purpose
Check if a script is being run by the root user.
### Arguments
None
### Returns
TRUE (0) if user is root, otherwise FALSE (1)
### Usage
```bash
root_user || die "User must be root." 1
```
### Notes
