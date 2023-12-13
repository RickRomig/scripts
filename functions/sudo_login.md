# sudo_login

1. **Purpose:** Prompts for user password if user is in the sudo group and there is not an active sudo session. Once the password is entered, the prompt line is blanked out after 2 seconds. If the user is not in the sudo group, an error message is displayed and the calling script exits.

2. **Arguments:** None

```bash
sudo_login() {
  if id -nG "$USER" | grep -qw sudo; then
    if ! sudo -vn 2>/dev/null; then
      sudo ls > /dev/null 2>&1
      sleep 2
      printf '\e[A\e[K'
    fi
  else
    die "$USER is not a member of the sudo group. Access denied." 1
  fi
}
```
