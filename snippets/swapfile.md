# swapfile

#### Manually creating a swap file:

```bash
$ sudo dd if=/dev/zero of=/swapfile bs=1024K count=2048
$ ls
$ sudo chmod 0600 /swapfile
$ sudo mkswap /swapfile
$ sudo nano /etc/fstab
/swapfile	none	swapfilesw
```
#### Zram swap file
```bash
$ sudo apt install zram-tools
$ sudo nano /etc/default/zramswap
# Uncomment ALGO=lz4
ALGO=lz4
# Uncomment Percent=50
PERCENT=25
```
