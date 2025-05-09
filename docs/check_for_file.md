# check_for_file
### Purpose
Checks for a needed support file in ~/bin/files.
### Arguments
File name to be checked.
### Notes
If the file is found, displays 'OK' for 1 second.
If the file is not found, exits the script using the `die` function.
### Code
```bash
check_for_file() {
  local file_dir target_file
  target_file="${1:-foo.bar}"
  file_dir="$HOME/bin/files"
  if [[ -f "$file_dir/$target_file" ]]; then
    printf "%s - OK\n" "$target_file"
    sleep 1
    printf '\e[A\e[K'
  else
    die "$target_file not found!" 1
  fi
}
```
