# in_repos
### Purpose
Returns true if a package is found in the distribution's repositories and returns false if the package is not found. This includes PPAs and other added softtware sources.
### Arguments
package to be checked
### Returns
TRUE or FALSE (0 or 1)
### Usage
```bash
in_repos package && sudo apt install package
```
### Code
```bash
 in_repos() {
  local in_repo package
  package="$1"
  in_repo=$(apt-cache show "$package" 2>/dev/null | awk '/Package:/ {print $NF}')
  [[ "$in_repo" ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
