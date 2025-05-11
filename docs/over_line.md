# over_line
### Purpose
Displays a line of a repeated single character above a line of text.
### Arguments
- A single line of text.
- A single character inside double-quotes ("-") to form the box.
### Returns
Outputs a line of text beneath a line of characters of the same length.
### Usage
```bash
over_line "A line of text." "*"
***************
A line of text.
```
### Code
```bash
# shellcheck disable=SC2001
over_line() {
  local char len line title
  title="$1"
  char="${2:--}"
  len=${#char}
  (( len > 1 )) && char=${char::1}
  line=$(echo "$title" | sed "s/./$char/g")
  printf "%s\n%s\n"  "$line" "$title"
}
```
### Notes
 A hyphen is the default character if no character is specified.
 If more than one character appears in the string, only the first character is used.
