# SSH on NAT VM

### Run from VM to allow transfers from host machine.
1. Generate ssh key on vm
```bash
ssh-keygen
```
2. Copy the key to the host machine
```bash
ssh-copy-id rick@192.168.122.1		# should this include '/.ssh/authroized_keys' ?
```
3. Copy/sync host's ~/bin directory to vm's bin directory
```bash
rsync -avh --delete rick@192.168.122.1:bin $HOME/bin/
```
### Backup virtual machines to a backup driive
```bash
rsync -av --delete --progress /vm-drive-folder/ /media/$USER/VM\ Backup/vm/
```
