# exists
### Purpose
Returns true if the program exists (is installed), false if it does not.
### Arguments
The program/command to be checked.
### Returns
Returns TRUE if the command/program exists, FALSE if it does not.
### Usage
```bash
exists <command> && echo "Installed" || echo "Not installed."
```
### Code

```bash
exists()
{
  command -v "$1" >/dev/null 2>&1 && return 0 || return 1
}
```
### Notes
