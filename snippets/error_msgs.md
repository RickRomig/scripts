# Notes on various error messages

#### Timeshift
Found stale mount for device '/dev/sda3' at path '/run/timeshift/151949/backup'
Unmounted successfully
E: Failed to remove directory
Ret=256
Timeshift now mounts devices to a temporary folder and unmounts the folder after use. Sometimes the temporary folder cannot be unmounted since the device is still busy. It will be unmounted in the next run. This message can be ignored.
***Notes:**
After the original error, the following message will appear after the listing.
Found stale mount for device '/dev/sda3' at path '/run/timeshift/989/backup'
Unmounted successfully

#### Battery errors
```bash
$ acpi -bi
Battery 0: Charging, 0%, charging at zero rate - will never fully charge.
Battery 0: design capacity 3794 mAh, last full capacity 3794 mAh = 100%
```