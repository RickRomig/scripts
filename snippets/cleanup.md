# Cleanup functions
### Purpose
To cleanup tmp files/directories after exit. The function is called by trap builtin.
### Usage
```bash
tmp_file=$(mktemp) || die "ERROR: Failed to create temporary file!" 1
tmp_dir=$(mktemp -d) || die "ERROR: Failed to create temporary diectory!" 1
trap cleanup EXIT
```
### Code
  ```bash
  cleanup()
  {
    if [ -f "$tmp_file" ]; then
      rm -f "$tmp_file"
    fi
  }

  cleanup(){ [ -d "$tmp_dir" ] && rm -rf "$tmp_dir"}
  ```
### Notes:
The cleanup function is called by the trap builtin.
