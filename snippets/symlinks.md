# Symbolic Links
### Basic syntax
```bash
ln -s <path to the file/folder to be linked> <the path of the link to be created>
ln -s /path/to/original /path/to/symlink  	# will fail if link already exists
ln -sf /path/to/original /path/to/symlink 	# create/update link
```
Full path to the file/folder to be linked is required.
### Create a symbolic link from gitea/scripts/ to bin
```bash
ln -s /home/rick/gitea/scripts bin
```
### Symlink to a file:
```bash
ln -s /home/james/transactions.txt trans.txt
ln -s /home/james/transactions.txt my-stuffs/trans.txt
```
### Symlink to a folder:
```bash
ln -s /home/james james
```
### Remove a symlink:
```bash
ls -l <path/to/assumed-symlink>
unlink <path/to/symlink>
rm <path/to/symlink>
rm trans.txt
rm james
```
The main benefit of `rm` over `unlink` is that you can remove multiple symlinks at once, like you can with files.

### Find broken links:
```bash
find /home/james -xtype l 	# This will list all broken symlinks in the james directory – from files to directories to sub-directories.
find /home/james -xtype l -delete		# Delete broken links
```
