# dots-spin
## dots
### Purpose
Display dots as a background process while waiting for an action to complete.
### Arguments
optional character to be repeated. Default is '.' (period)
2. **Function**


### Usage
   ```bash
   echo -n "Downloading update..."
   dots
   wget -q -P "$tmp_dir" "$url/$package"
   kill "$!"
   echo ""
   tput cnorm
   ```
### Code
```bash
dots() {
  local char len
  char="${1:-.}"
  len="${#char}"
  (( len > 1 )) && char=${char::1}  # takes the firt character.
  tput civis  # rempves cursor
  while true; do echo -n "."; sleep 0.5; done &
}
```
## spin
### Purpose
Display a spinning character as a background process while waiting for an action to complete.
### Arguments
None
### Usage
```bash
echo "Downloading update."
spin
wget -q -P "$tmp_dir" "$url/$package"
kill "$!"
echo ""
tput cnorm
```
### Code
```bash
spin() {
   spinner=( '|' '/' '-' '\' )
   while true; do for i in "${spinner[@]}"; do echo -ne "\r$i"; sleep 0.2; done; done &
}
```
### Notes
Spin function has been removed from functionlib because it's problematic and I rarely used it.
