# bin_in_path
### Purpose
Return true if  `$HOME/bin` is in the PATH.
### Arguments
None
### Returns
True or False (0 or 1)
### Code
```bash
function bin_in_path()
{
  echo "$PATH" | grep -q "$HOME/bin" && return $TRUE || return $FALSE
}
```
