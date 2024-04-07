# sed add/del/append

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
