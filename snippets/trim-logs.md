# Trim logs

### Reduce a log file to 30 lines by removing one line at a time from the top.
```bash
LOG_LEN=$(wd -l "$LOG_FILE" | cut -d' ' -f1)
while [[ "$LOG_LEN" -gt 30 ]]; do
  sed -i '1d' "$LOG_FILE"
  (( LOG_LEN-- ))
done
```
### Remove 1 line from the top of a log file if greater than 30 lines.
- In BASH
```bash
LOG_LEN=$(wc -l "$LOG_FILE" | cut -d " " -f1)
(( LOG_LEN > 30 )) && sed -i '1d' "$LOG_FILE"
```
- In a POSIX shell (SH)
```sh
LOG_LEN=$(wc -l "$LOG_FILE" | cut -d " " -f1)
[ "$LOG_LEN" -gt 30 ] && sed -i '1d' "$LOG_FILE"
```
### Remove 1 line from the top of a log file if greater than 30 lines and the second line of a 2-line entry.
- In BASH
```bash
LOG_LEN=$(wc -l "$LOG_FILE" | awk '{print $1}')
(( LOG_LEN > 30 )) && sed -i '1d' "$LOG_FILE"
LINE_ONE=$(sed -n '1p' "$LOG_FILE" | awk '{print $1}')
[[ "$LINE_ONE" = "Updated" ]] && sed -i '1d' "$LOG_FILE"
```
- In a POSIX shell (SH)
```sh
LOG_LEN=$(wc -l "$LOG_FILE" | awk '{print $1}')
[ "$LOG_LEN" -gt 30 ] && sed -i '1d' "$LOG_FILE"
LINE_ONE=$(sed -n '1p' "$LOG_FILE" | awk '{print $1}')
[ "$LINE_ONE" = "Updated" ] && sed -i '1d' "$LOG_FILE"
```
### Trim logs from youtube-dl updates
```bash
# Remove 2nd line of an 'Updated' entry.
sed -i '/^Updated/d' "$log_dir/$log_file"
# Truncate ERROR line.
sed -i '/ERROR/s/ Please try again later.//' "$log_dir/$log_file"
# Remove oldest entry if more than 30 entries
log_len=$(wc -l "$log_dir/$log_file" | cut -d ' ' -f1)
[[ "$log_len" -gt 30 ]] && sed -i '1d' "$log_dir/$log_file"
```