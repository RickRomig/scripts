# debian_based
### Purpose
Check if the running distribution is Debian-based (Ubuntu, Mint, BunsenLabs, antiX, MX)
### Arguments
None
### Returns
TRUE (0) if distributions is Debian-based, FALSE (1) if it is not.
### Code
```bash
debian_based() {
  local like_deb
  like_deb=$(grep -E 'ID|ID_LIKE' /etc/os-release | grep -w debian)
  [[ "$like_deb" ]] && return "$TRUE" || return "$FALSE"
}
```
