# remove_tilde
### Purpose
Remove backup files appended by a tilde in the current directory.
### Arguments
None
### Returns
Nothing
### Usage
```bash
remove_tilde
```
### Code
```bash
remove_tilde() {
  local nbu
  nbu=$(find ./ -maxdepth 1 -type f -regex '\./.*~$' | wc -l)
  (( nbu > 0 )) && find . -maxdepth 1 -type f -regex '\./.*~$' -exec rm {} \;
}
```
### Notes
