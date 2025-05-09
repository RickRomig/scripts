# check_package
### Purpose
Checks if a package is installed and installs the package if it is not.
### Arguments
Takes the name of the package to be checked/installed.
### Code
```bash
check_package() {
  local package="$1"
  if dpkg -l | grep -qw "$package"; then
    printf "%s [OK]\n" "$package"
    sleep 1
    printf '\e[A\e[K'
  else
    printf "Installing %s ...\n" "$package"
    sudo_login 1
    sudo apt-get install "$package" -yyq
  fi
}
```
