# Commands to copy an iso file to a USB stick

Use lsblk to confirm USB device
```bash
$ sudo cat /path/to/iso > /dev/sdx

$ sudo cp /path/to/iso /dev/sdx

$ sudo dd if=file.iso of=/dev/sdx status=progress bs=4M oflag=sync

$ sudo dd if=file.iso of=/dev/sdx bs=4M; sync

$ sudo dd if=file.iso of=/dev/sdx bs=4M && sync
```
The `cp` or `dd` methods must be used for BunsenLabs ISO files.
Recommended for Debian ISO files.
