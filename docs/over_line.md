# over_line
### Purpose
Displays a line of a repeated single character above a line of text.
### Arguments
 $1 -> A single line of text to be displayed.
$2 -> Optional character to form the line. Default is `-`
### Returns
Outputs a line of text beneath a line of characters of the same length.
### Usage
```bash
over_line "A line of text." "*"
***************
A line of text.
```
### Notes
- The line of text cannot contain any special characters.
- A hyphen is the default character if no character is specified.
- The character argument, if present, needs to be in double quotes, i.e., "-" and only the first character is used.
