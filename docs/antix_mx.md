# antix_mx
### Purpose
Return true if the current distribution is antiX or MX Linux.
### Arguments
None
### Returns
True or False (0 or 1)
### Notes
Specifically checks for antiX or MX Linux. The `is_debian` function will return true with either of these distributions.
### Code
```bash
antix_mx() {
  DIST_ID=$(grep 'DISTRIB_ID' /etc/lsb-release 2> /dev/null | cut -d '=' -f2)
  case $DIST_ID in
    antiX|MX )
      return "$TRUE" ;;
    * )
      return "$FALSE" ;;
  esac
}
```
