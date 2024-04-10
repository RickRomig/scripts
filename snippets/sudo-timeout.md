# Change sudo timeout for a user
```bash
# per-user sudo timeout
$ cd /etc/sudoers.d/
$ sudo visudo -f rick
Defaults timestamp_timeout=30
```