# To remove an inactive device from /dev:
```bash
# For instance, if there is a /dev/sdb directory but the device doesn't exist.
sudo bash -c 'echo 1 > /sys/block/sdX/device/delete'
# Substitute the device name to be deleted for sdX.
```