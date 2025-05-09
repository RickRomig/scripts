# center_file
### Purpose
Displays the contents of a text file with each line centered.
### Arguments
The text file to be displayed.
### Usage
```bash
center_file "text file to be centered"
```
### Code
```bash
center_file() {
  local columns line
	columns="$(tput cols)"
	while IFS= read -r line; do
		printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
	done < "$1"
}
```
