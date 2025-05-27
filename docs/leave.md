# leave
### Purpose
Display either a random message when exiting a script or an optional message string passed as an argument before exiting the script.
### Arguments
Optional exit message.
### Returns
Displays input message or random message from a file.
### Usage
```bash
leave ""
leave "Some text"
```
### Code
```bash
leave() {
  local message message_file
  message_file="$HOME/.local/share/doc/leave.txt"
  message="$1"
  message="${message:-$(shuf -n 1 "$message_file")}"
  printf "%s\n" "$message"
  exit 0
}
```
### Notes
The message file is stored in `~/.local/share/doc/leave.txt`.
No need to add an empty string as an argument. The script checks for that and makes the random message the default.
