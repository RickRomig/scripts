# Timeshift

### Timeshift jobs can be schedule by editing the json file.
```bash
nano /etc/timeshift/timeshift.json
{
  "backup_device_uuid" : "0f4a8008-1742-400a-951a-7b994b58cd18",
  "parent_device_uuid" : "",
  "do_first_run" : "false",
  "btrfs_mode" : "false",
  "include_btrfs_home_for_backup" : "false",
  "include_btrfs_home_for_restore" : "false",
  "stop_cron_emails" : "true",
  "btrfs_use_qgroup" : "true",
  "schedule_monthly" : "true",
  "schedule_weekly" : "true",
  "schedule_daily" : "true",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "2",
  "count_weekly" : "3",
  "count_daily" : "5",
  "count_hourly" : "6",
  "count_boot" : "5",
  "snapshot_size" : "6377926014",
  "snapshot_count" : "333045",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  "exclude" : [
    "/home/rick/**",
    "/var/lib/libvirt/**",
    "/root/**"
  ],
  "exclude-apps" : [
  ]
}
```
