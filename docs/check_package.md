# check_package
### Purpose
Checks if a package is installed and installs the package if it is not.
### Arguments
$1 -> name of package to check and/or install
### Note
If set -o pipefail is used in script, function may try to install package even if already installed.
