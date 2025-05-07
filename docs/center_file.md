# center_file
1. **Purpose:** Display the contents of a text file with each line centered.
2. **Arguments:**
	- The text file to be displayed.
3. **Code:**

```bash
center_file() {
  local columns line
	columns="$(tput cols)"
	while IFS= read -r line; do
		printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
	done < "$1"
}
```
