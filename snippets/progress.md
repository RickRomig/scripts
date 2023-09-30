# showing progress
```bash
$	pv testfile | grep error
$ pv testfile > testfile2     # copy with progress
$ (pv -n testfile > testfile2) 2>&1 | dialog --gauge 'copy status' 6 60

$ tar --checkpoint=1000 -cf test.tar *
$ tar --checkpoint=.1000 -cf test.tar *   # show dots

$ rsync --progresss
```
#### Shell script progress.sh
```bash
#!/bin/bash
while true; do echo -n "."; sleep 1; done &
trap 'kill $!' SIGTERM SIGKILL

echo "Running tar command:"
tar -df test.tar ./*
echo "done"

kill $!
```