# installed.md
### Purpose
Check is a package is currently installed using dpkg --list
### Arguments
$1 -> package to be checked.
### Returns
TRUE (0) if the package is currently installed, otherwise returns FALSE (1).
### Usage
```bash
installed && do_something || do_something_else
```
### Notes
- Used with package installed by `apt', `dpkg` or `gdebi`
+ Does not work with packages installed by downloading/copying a binary to a directory such as `/userbin` or `/user/local/bin`.
- May be useful for packages that are not installed to a directory not in the user's path, i.e., `/sbin`
