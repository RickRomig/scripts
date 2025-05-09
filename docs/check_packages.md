# check_packages
### Purpose
Checks several packages to see if they are installed and installs them if they are not.
### Arguments
Takes an array of package names to be checked.
### Usage
```bash
packages=( pkg1 pkg2 ... )
check_packages "${packages[@]}"
```
### Notes
If `set -o pipefail` is used in script, function will try to install package even if already installed.
### Code
```bash
check_packages() {
	local pkg pkgs
  pkgs=("$@")
	for pkg in "${pkgs[@]}"; do
		if dpkg -l | grep -qw "$pkg"; then
			printf "%s - OK\n" "$pkg"
      sleep 1
      printf '\e[A\e[K'
		else
			printf "Installing %s ...\n" "$pkg"
			sudo apt-get install "$pkg" -yyq
		fi
	done
}
```
