# Purge obsolete kernel configuration files after removing the old kernel
```bash
$ sudo apt remove --purge $(dpkg -l | awk '/^rc/ {print $2}')
```
#### Alternate implementations
```bash
rcpkgs=$(dpkg -l | awk '/^rc/ {print $2}')
if [[ -n "$rcpkgs" ]]; then
  for rcpkg in $(dpkg -l | awk '/^rc/ {print $2}'); do
    sudo apt-get remove --purge "$rcpkg" -yy
  done
else
  echo "No files to be purged found."
fi

rcpkgs=$(dpkg -l | awk '/^rc/ {print $2}')
if [[ -n "$rcpkgs" ]]; then
  for rcpkg in "${rcpkgs[@]}"; do
    sudo apt-get remove --purge "$rcpkg" -yy
  done
else
  echo "No files to be purged found."
fi
```
