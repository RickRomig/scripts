# dmidecode information
```bash
sudo dmidecode -s system-manufacturer
cat /sys/class/dmi/id/sys_vendor

sudo dmidecode -s product-name
cat /sys/class/dmi/id/product_name

sudo dmidecode -s system-version
cat /sys/class/dmi/id/product_version

sudo dmidecode -s system serial-number
cat /sys/class/dmi/id/product_serial

sudo dmidecode -s processor-version
lscpu | awk -F: '/Model name:/ {print $NF}' | awk '{$1=$1}1' | sed 's/([^)]*)//g'
```
**Note:** dmidecode to get processor name does not work for all systems.
Dell Latitude E6500 must use lscpu method
