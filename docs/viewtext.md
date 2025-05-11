# viewtext
### Purpose
View a text file in a terminal, automatically choosing cat or less.
### Arguments
Name of the file to be viewed.
### Returns
Nothing. Displays the contents of the file.
### Usage
```bash
viewtext foobar.txt
```
### Code
```bash
viewtext() {
  local catmax file filelines
  file="$1"
  catmax=$(( $(tput lines)*87/100 ))
  filelines=$(wc -l < "$file")
  if [[ "$filelines" -gt "$catmax" ]]; then less "$file"; else cat "$file"; fi
}
```
### Notes
Automatically chooses `cat` or `less` to view the file based on the ratio of the number of lines in the file and in the terminal.
