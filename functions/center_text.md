# center_text
1. **Purpose:** Display a string with the line centered.
2. **Arguments:**
	- A string of text.
3. **Code:**
```bash
center_text() {
  local columns line
	columns="$(tput cols)"
	while IFS= read -r line; do
		printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
	done <<< "$1"
}
```
