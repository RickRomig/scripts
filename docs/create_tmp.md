# create_tmp
## creat_tmp()
### Purpose
Create a temporary file and/or directory in a script.
### Arguments
$1 -> A string indicating whether to create a temporary file, directory, or both.
* The argument can be `dir`, `file`, or `dirfile`.
Anything else will cause the function to exit the script with an error message.
### Usage
```bash
create_tmp [dir|file|dirfile]
```
## cleanup()
### Purpose
Delete the temporary file/directory created by `create_tmp`.
### Arguments
None
### Usage
Function is called by `trap` when the calling script exits.

