# Printers

#### List printers:
```bash
$ lpstat -p | awk '{print $2}'
# list printers and printer queues
$ lpstat -p | awk '{print $2}' | xargs -n1 lpq -P
# Remove a printer (Requires sudo if user not in the lpadmin group)
$ lpadmin -x <printer_name>
# Set default printer
$ lpoptions -d <printer_name>
```
#### Ensure that the CUPS package is installed on your Linux system and if not, install it using your package manager:
sudo apt install cups
```

You may download CUPS and PPD files direct from the CUPS website at: https//www.cups.org/

Find the Postscript Printer Description (PPD) file for your printer. Typically installed with the cups package and stored under:
```bash
/usr/share/cups/model/
/usr/share/ppd/cupsfilters
```
#### list of available printers and drivers i.e. device-uri
$ lpinfo -l
$ lpinfo -v   # list devices
$ lpinfo -m   # list drivers
$ lpinfo --make-and-model "HP LaserJet" -m
```
#### Add your printer using the following command:
```bash
$ lpadmin -p “HP-LaserJet-CM3530-1” -D “Human Resources Department” -P /usr/share/ppd/cupsfilters/HP-Color_LaserJet_CM3530_MFP-PDF.ppd -E -v file:///dev/PRINTER_PATH
# -v represents the device-uri as seen in previous step.
```