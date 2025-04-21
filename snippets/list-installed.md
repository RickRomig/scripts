# List installed packages

## Commands to list installed packages on a Debian-based system and install or reinstall on a new system.

1. List packages and store in a file.
```bash
$ dpkg --get-selections | awk '/install/ {print $1}' > packages.lst		# Add path as required.
$ cat packages.lst 	# use less or bat to page through it.
```
2. Install/reinstall packages in the list.
```bash
$ sudo apt install -y dselect		# probaby not installed by default but necessary on the backend.
$ sudo apt install $(cat packages.lst) -yy		# Add path as required.
```
## NOTES
1. List will include all packages installed through the APT package manager (apt, apt-get, dpkg, gdebi, synaptic).
2. List will not include packages installed through other means such as Micro, Gitea, flatpaks, snaps, app images.
3. If applied to a new system, `bat` will be installed from distribution repositories and renamed to `batcat`.
4. Third party packages such as browsers will require a source.list file in `/etc/apt/source.list.d` and possibly GPG key files.
5. Most third party packages will need to be installed from scripts.
