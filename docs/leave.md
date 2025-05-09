# leave
### Purpose
Display either a random message when exiting a script or an optional message string passed as an argument before exiting the script.
### Arguments
Optional exit message.
### Returns
Nothing
### Usage
```bash
leave ""
leave "Some text"
```
### Code
```bash
leave() {
  local message msg_file
  message="$1"
  msg_file="$HOME/.local/share/doc/leave.txt"
  [[ "$message" ]] || message=$(shuf -n 1 "$msg_file")
  printf "%s\n" "$message"
  exit 0
}
```
### Notes
The message file is stored in `~/.local/share/doc/leave.txt`.
