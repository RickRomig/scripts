# support_ppa function
### Purpose
Checks if the installed distribution supports Ubuntu Personal Package Archives (PPA).
### Arguments
None
### Returns
TRUE (0) ipf PPA is officially supported, otherwise FALSE (1)
### Usage
```bash
support_ppa || die "PPA not supported." 1
```
### Notes
- Personally, I avoide the use of PPAs with Linux Mint and use Flatpak instead.
