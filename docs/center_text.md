# center_text
### Purpose
Display a string with the line centered.
### Arguments
A string of text.
### Usage
```bash
$ center_text "Text string"
```
### Code
```bash
center_text() {
  local columns line
	columns="$(tput cols)"
	while IFS= read -r line; do
		printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
	done <<< "$1"
}
```
