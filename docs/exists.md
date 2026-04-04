# exists
### Purpose
Checks if a program exists in the user's path.
### Arguments
$1 -> command/program to be checked.
### Returns
Returns TRUE (0) if the command/program exists in the user's path, FALSE (1) if it does not.
### Usage
```bash
exists <command> && echo "Installed" || echo "Not installed."
```
### Notes
