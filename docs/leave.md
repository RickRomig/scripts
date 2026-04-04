# leave
### Purpose
Display either a random message when exiting a script or an optional message string passed as an argument before exiting the script.
### Arguments
$1 -> Exit message (Optional)
### Returns
Displays input message or random message from a file.
### Usage
```bash
leave ""
leave "Some text"
```
### Notes
- The message file is stored in `~/.local/share/doc/leave.txt`.
- No need to add an empty string as an argument. The script checks for that and, by default, selects a random message from leave.txt file.
