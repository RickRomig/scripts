# leapyear
### Purpose
Determine if a given year is a leap year.
### Arguments
4-digit year to be checked.
### Returns
Return true (0) if the current year is a leap year, otherwhise false (1).
### Usage
```bash
leapyear && do something
if leapyear; then
  echo "February has 29 days."
else
  echo "February has 28 days."
fi
```
### Code
```bash
leapyear() {
  local year="$1"
  [[ $(( year % 4 )) -ne 0 ]] && return "$FALSE"
  [[ $(( year % 400 )) -eq 0 ]] && return "$TRUE"
  [[ $(( year % 100 )) -eq 0 ]] && return "$FALSE" || return "$TRUE"
}
```
### Notes
