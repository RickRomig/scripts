# To find WiFi passwords on a Linux system

```bash
sudo grep -r '^psk=' /etc/NetworkManager/system-connections/
/etc/NetworkManager/system-connections/Auto mosfanet1.nmconnection:psk=P1ayn@k3d
/etc/NetworkManager/system-connections/Auto mosfanet.nmconnection:psk=P1ayn@k3d
```
Examples
```bash
sudo grep -r '^psk=' /etc/NetworkManager/system-connections/ | cut -d'/' -f5 | sed 's/.nmconnection:psk=/ = /'
mosfanet1 = P1ayn@k3d
mosfanet = P1ayn@k3d

sudo grep -hr '^psk=' /etc/NetworkManager/system-connections/
psk=P1ayn@k3d
psk=P1ayn@k3d
```
