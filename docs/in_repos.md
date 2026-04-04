# in_repos
### Purpose
Checks if a package is found in the distribution's repositories. This includes PPAs and other added softtware sources.
### Arguments
$1 -> package to be checked
### Returns
TRUE (0) if package is found in repositories, FALSE (0) if not.
### Usage
```bash
in_repos package && sudo apt install package
```
### Notes
