# sed snippets
### Sample file
```bash
$ cat edit.sh
input="file1"
while read -r line
do
  echo ${line //.0./.56}
done < "$input"
```
### add the shebang
```bash
$ sed '1i #!/bin/bash' edit.sh
$ sed -i '1i #!/bin/bash' edit.sh   # insert as 1st line
```
### remove the shebang
```bash
$ sed -i '1d' edit.sh
$ sed -i '/#!\/bin\/bash/d' edit.sh
```
### insert on the line below
```bash
$ sed -i '/done/a #End of loop' edit.sh
```
### Change config files
```bash
$ cp /etc/sshd_config .
$ sed -n '/^PermitRootLogin/p' sshd_config
PermitRootLogin no
$ sed -n '^PermitRootLogin/s/ no/ yes/p' sshd_config
$ sed -i '^PermitRootLogin/s/ no/ yes/' sshd_config
```
### Insert lines
```bash
$ sed -i '/echo/i #!/bin/bash' file.sh  # insert on the line above
$ sed -i '/echo/a #EndOfScript' file.sh # insert on the line below
```
### remove commented and blank lines.
```bash
sed -E '/^($|#)/d' filename
```
### creates a dated backup file before writing the file.
```bash
sed -i.$(date +%F) '/^#/d;/^$/d' filename
```
### clean up original BP log
```bash
sed -i.$(date +%F) '/^Date/d; s/[0-9]'[0-9][0-9\/[0-9][0-9]/& mmHg/; s/6[0-9]/& bpm/' BP-Daily.txt
```
### Using sed to rename files containing spaces.
```bash
ls | while read file; do mv "$file" "$(echo "$file" | sed 's/\ /_/g')"; done
ls | while read file
do
	mv "$file" "$(echo "$file" | sed 's/\ /_/g')"
done
```
### Will generate errors if file cannot be renamed.
```bash
find . -maxdepth 1 -type f | grep " " >/dev/null && rename -v 's/ /_/g' ./* || echo "No filenames containing spaces found."
```
### Copy `/etc/nanorc` to `~/.config/nano/` and run `nano.sed` on it.
```bash
cp /etc/nanorc .config/nano/nanorc; sed -i -f bin/files/nano.sed .config/nano/nanorc
```
### Remove leading or trailing whitespace
```bash
sed -e 's/^[ \t]*//g' filename		# remove leading whitespace
sed -e 's/\ *//g' filename				# remove trailing whitespace
```