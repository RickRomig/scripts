# dots-spin
## dots
### Purpose
Display a continuing series of dots as a background process while waiting for an action to complete.
### Arguments
$1 -> optional character to be repeated. Default is '.' (period)
DOTS_PID	# Global variable
### Usage
   ```bash
   DOTS_PID=
   printf "Downloading update..."
   dots "." &
	DOTS_PID="$!"
   wget -q -P "$tmp_dir" "$url/$package"
	kill_dots
   ```
### Notes
- Character argument, if present, needs to be in double quotes, i.e., "-". Recommend always including it in the call to it.
- DOTS_PID needs to be declared as a global variable in the calling script.
- Dots function adapted From Dave Eddy's spinner code.

## kill_dots
### Purpose
kill the dots background process and restores the cursor.
### Arguments
DOTS_PID	# Global variable
### Usage
See `dots` above
### Notes
- DOTS_PID needs to be declared as a global variable in the calling script.

## spin
### Purpose
Display a spinning character as a background process while waiting for an action to complete.
### Arguments
SPIN_PID	# Global variable
### Usage
```bash
SPIN_PID=
echo "Downloading update."
spin &
SPIN_PID="$!"
wget -q -P "$tmp_dir" "$url/$package"
kill_spin
```
### Notes
SPIN_PID needs to be declared as a global variable in the calling script.

## kill_spin
## Purpose
Kill the dots background process and restores the cursor.
### Arguments
SPIN_PID	# Global variable
### Usage
See `spin` above
### Notes
- SPIN_PID needs to be declared as a global variable in the calling script.
- Spin function based on code by Deve Eddy, URL: https://github.com/bahamas10/ysap/raw/refs/heads/main/code/2026-01-07-spinner/spinner
