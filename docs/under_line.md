# under_line
### Purpose
Display a line of a single character under a line of text.
### Arguments
- A single line of text.
- A single character inside double-quotes ("-") to form the line.
### Returns

### Usage
```bash
```
### Code
```bash
# shellcheck disable=SC2001
under_line() {
  local char len line title
  title="$1"
  char="${2:--}"
  len=${#char}
  (( len > 1 )) && char=${char::1}
  line=$(echo "$title" | sed "s/./$char/g")
  printf "%s\n%s\n" "$title" "$line"
}
```
### Notes
- A hyphen is the default character if no character is specified.
- If more than one character appears in the string, only the first character is used.
