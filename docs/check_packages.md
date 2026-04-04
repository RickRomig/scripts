# check_packages
### Purpose
Checks several packages to see if they are installed and installs them if they are not.
### Arguments
`$@` -> array of packages to check and/or install
### Usage
```bash
packages=( pkg1 pkg2 ... )
check_packages "${packages[@]}"
```
### Note
If `set -o pipefail` is used in script, function will try to install package even if already installed.
