# print_line
### Purpose
Print a line consisting of a single character.
### Arguments
- the character to be printed in the line
- the length of the line to be printed
### Returns
Outputs a line using a single character of a specified length.
### Usage
```bash
print_line "*" "40"
```
### Code
```bash
print_line() {
  local char width len
  char="${1:-=}"
  width=$(tput cols)
  if [[ "$#" -gt 1 ]]; then char="$1"; width="$2"; fi
  len=${#char}
  (( len > 1 )) && char=${char::1}
  printf "%${width}s\n" | sed "s/ /$char/g"
}
```
### Notes
- If no arguments are passed defaults to a line of `=` the full width of the termninal screen.
- The character argument must be enclosed in double quotation marks.
- If the character argument contains more than a single character, the first character is used.
- The second argument, if passed, must be an integer value.
- The `tr` command was originally used (`tr " " "\$CHAR"`). The `sed` command replaced it because it supports unicode characters.
