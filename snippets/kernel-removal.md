# Removing Old Kernels from Debian/LMDE
[Linux Mint Forums](https://forums.linuxmint.com/viewtopic.php?t=409031)
1. Determine the running kernel:
```bash
$ uname -r
```
2. View installed kernels:
```bash
$ grep linux-image <(dpkg --list)
```
3. List installed headers:
```bash
$ grep linux-headers <(ls /usr/src/)
```
4. Remove old kernels.
  - Remove the headers first. (Repeat for each old header)
```bash
$ sudo apt-get purge linux-headers-6.x.x-xx-amd64	# Debian
$ sudo apt-get purge linux-image-6.x.x-xx+deb13-amd64	# LMDE 7
$ sudo apt-get purge linux-image-6.x.x-xx+deb13-common	# LMDE 7
```
  - After removing the headers, remove the image. (Repeat for each old image)
```bash
$ sudo apt-get purge linux-image-6.x.x-xx-amd64	# Debian
$ sudo apt-get purge linux-image-6.x.x-xx+deb13-amd64	# LMDE 7
```
5. Restart the PC, to check if everything is working.
```bash
$ sudo systemctl reboot
```
6. Verify that the kernel and headers have been removed.
```bash
$ uname -r
$ grep 'linux-image' <(dpkg -l); grep 'linux-headers' <(ls /usr/src/)
```
## NOTES
- Be sure to retain at least two kernals, the current kernel and the one that immediately preceded it.
