# Spice agent for VM
#### Install spice agent for vm
```bash
$ sudo apt install spice-vdagent -y
$ sudo apt install qemu-guest-agent -y
```
#### Start spice agent service
```bash
$ sudo systemctl status spice-vdagentd
$ sudo systemctl start spice-vdagentd
$ sudo systemctl status qemu-guest-agent.service
$ sudo systemctl start qemu-guest-agent.service
```