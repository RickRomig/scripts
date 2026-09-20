# Create Static IP on Debian
1. Edit `/etc/network/interfaces`.
* Add the following information:
```bash
$ sudo micro /etc/network/interfaces
auto enp7s0
iface enp7s0 inet static
	address 192.168.0.25
	netmask 255.255.255.0
	gareway 192.168.0.1
	dns-nameservers 8.8.8.8, 8.8.4.4
```
* Save the file
2. Restart the network interface.
```bash
$ sudo /etc/init.d/networking restart
$ sudo systemctl restart networking
$ sudo systemctl restart NetworkManager
$ ifdown eth1; ifup enp7s0
```
3. Confirm setup
```bash
$ ip address show enp7s0
```
