# To find WiFi passwords on a Linux system

```bash
sudo grep -r '^psk=' /etc/NetworkManager/system-connections/
/etc/NetworkManager/system-connections/Auto mosfanet1.nmconnection:psk=*********
/etc/NetworkManager/system-connections/Auto mosfanet.nmconnection:psk=*********
```
Examples
```bash
sudo grep -r '^psk=' /etc/NetworkManager/system-connections/ | cut -d'/' -f5 | sed 's/.nmconnection:psk=/ = /'
mosfanet1 = *********
mosfanet = *********

sudo grep -hr '^psk=' /etc/NetworkManager/system-connections/
psk=*********
psk=*********
```
