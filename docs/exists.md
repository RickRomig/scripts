# exists
### Purpose
Returns true if the program exists in the user's path, false if it does not.
### Arguments
The program/command to be checked.
### Returns
Returns TRUE (0) if the command/program exists in the user's path, FALSE (1) if it does not.
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
