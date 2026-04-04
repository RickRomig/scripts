# print_line
### Purpose
Print a line consisting of a single character.
### Arguments
$1 -> character to be printed (optional, = is the default)
$2 -> integer length of the line (optional), width of terminal is the default.
### Returns
Outputs a line using a single character of the specified length.
### Usage
```bash
print_line "*" "40"
```
### Notes
- If no arguments are passed defaults to a line of `=` the full width of the termninal screen.
- The character argument must be enclosed in double quotation marks.
- If the character argument contains more than a single character, the first character is used.
- The second argument, if passed, must be an integer value and follow a character argument.
- The `tr` command was originally used (`tr " " "\$CHAR"`). The `sed` command replaced it because it supports unicode characters.
