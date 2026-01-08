# dots-spin
## dots
### Purpose
Display a continuing series of dots as a background process while waiting for an action to complete.
### Arguments
optional character to be repeated. Default is '.' (period)
### Usage
   ```bash
   DOTS_PID=
   printf "Downloading update..."
   dots "." &
	DOTS_PID="$!"
   wget -q -P "$tmp_dir" "$url/$package"
	kill_dots
   ```
### Code
```bash
dots() {
	local char="${1:-.}"
	local char_len="${#char}"
	(( char_len > 1 )) && char="${char::1}"
	tput civis
	while true; do
		printf '.'
		sleep .5
	done
}

kill_dots() {
	if [[ -n "$DOTS_PID" ]]; then
		kill "$DOTS_PID"
		printf "done\n"
	fi
	tput cnorm
}
```
## spin
### Purpose
Display a spinning character as a background process while waiting for an action to complete.
### Arguments
None
### Usage
```bash
SPIN_PID=
echo "Downloading update."
spin &
SPIN_PID="$!"
wget -q -P "$tmp_dir" "$url/$package"
kill_spin
```
### Code
```bash
spin() {
	local c
	local chars=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
	tput civis
	while true; do
		for c in "${chars[@]}"; do
			# print ' %s \r' "$c"
			echo -ne " $c \r"
			sleep .2
		done
	done
}

kill_spin() {
	if [[ -n "$SPIN_PID" ]]; then
		kill "$SPIN_PID"
	fi
	printf "\n"
	printf '\e[A\e[K'
	tput cnorm
}

```
### Notes
- Spin function based on code by Deve Eddy, URL: https://github.com/bahamas10/ysap/raw/refs/heads/main/code/2026-01-07-spinner/spinner
- Dots function adapted From Dave Eddy's spinner code.
