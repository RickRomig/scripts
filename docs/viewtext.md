# viewtext
### Purpose
View a text file in a terminal, automatically choosing cat or less depending on the length of the file.
### Arguments
$1 -> file to be viewed
### Returns
Nothing. Displays the contents of the file.
### Usage
```bash
viewtext foobar.txt
```
### Notes
Automatically chooses `cat` or `less` to view the file based on the ratio of the number of lines in the file and in the terminal.
