# support_ppa function
### Purpose
Checks if the installed distribution supports Ubuntu Personal Package Archives (PPA).
### Arguments
None
### Returns
TRUE (0) or FALSE (1)
### Usage
```bash
support_ppa || die "PPA not supported." 1
```
### Code
```bash
support_ppa() {
  local codename
  codename=$(/usr/bin/lsb_release --codename --short)
  case "$codename" in
    jammy|noble|vanessa|vera|victoria|virginia|wilma|xia )
      return "$TRUE"
    ;;
    * )
      return "$FALSE"
  esac
}
```
### Notes
