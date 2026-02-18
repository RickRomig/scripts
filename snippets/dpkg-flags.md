# dpkg flags

- First letter → desired package state ("selection state"):
	- u ... unknown
  - i ... install
  - r ... remove/deinstall
  - p ... purge (remove including config files)
  - h ... hold

- Second letter → current package state:
  - n ... not-installed
  - i ... installed
  - c ... config-files (only the config files are installed)
  - U ... unpacked
  - F ... half-configured (configuration failed for some reason)
  - h ... half-installed (installation failed for some reason)
  - W ... triggers-awaited (package is waiting for a trigger from another package)
  - t ... triggers-pending (package has been triggered)

- Third letter → error state (you normally shouldn't see a third letter, but a space, instead):
  - R ... reinst-required (package broken, reinstallation required)

