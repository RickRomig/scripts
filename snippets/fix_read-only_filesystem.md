# Fix read-only fileystem
Problem occurred on the HP-6005

su to root user
```bash
$ su -
# umount /dev/sdb1
# e2fsck /dev/sdb1
# mount /dev/sdb1
# exit
```