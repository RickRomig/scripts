# SSH on NAT VM

### Run from VM to allow transfers from host machine.
1. Generate ssh key
```bash
ssh-keygen
```
2. Copy the key to the host machine
```bash
ssh-copy-id rick@192.168.122.1
```
3. Copy/sync host's ~/bin directory
```bash
rsync -avh --delete rick@192.168.122.1:bin $HOME/bin/
```
