# Mount usb drive if not automatically mounted.
```bash
# Detect USB drive
$ sudo fdisk -l
# Create mount point
$ mkdir /media/rick/BU_Drive 
# Mount the USB drive
$ sudo mount /dev/sdb1 /media/BU_Drive/
# Confirm drive is mounted
$ mount | grep sdb1
```