# is_debian
### Purpose
Return true if the distribution is based on Debian, otherwise returns false.
### Arguments
None
### Returns
Returns 0 (TRUE) if Debian, LMDE, Antix, or MX Linux, otherwise returns 1 (FALSE).
### Usage
```bash
is_debian && do someting
```
### Code
```bash
is_debian() {
  local codename
  codename=$(/usr/bin/lsb_release --codename --short)
  case "$codename" in
    bookworm|bullseye|faye|boron )
      return "$TRUE"
    ;;
    * )
      return "$FALSE"
  esac
}
```
### Notes
