# Commands to wipe hard drives

### Shred (part of the coreutils package)
```bash
sudo shred -v /dev/sdx			# 3 passes by default. -v = verbose
sudo shred -v -n 1 /dev/sdx	# 1 pass
sudo shred -v -n 1 --random-source=/dev/urandom -z /dev/sdx	# 1 pass of random data, then overwrite with zeros
```
| Option | Action|
| -v --verbose | Show progress|
| -n --iterations=N |	Number of itereations (passes)|
| -z --zeros |	Final overwrite with zeros to hide shredding|

### Wipe
```bash
sudo apt install wipe
sudo wipe /dev/sdx
```
### dd
```bash
sudo dd if=/dev/urandom of=/dev/sdx bs=4096 status=progress
sudo dd if=/dev/zero of=/dev/sdx bs=4096 status=progress
```
