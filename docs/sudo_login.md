# sudo_login
### Purpose
Prompts for the sudo password if user is in the sudo group and there is not an active sudo session.
### Arguments
An integer value for the length of the delay in seconds before the prompt line is blanked and the script contintues.
### Returns
Nothing
### Usage
```bash
sudo_login 2
```
### Code
```bash
sudo_login() {
  local delay="${1:-2}"
  if id -nG "$USER" | grep -qw sudo; then
    if ! sudo -vn 2>/dev/null; then
      sudo ls > /dev/null 2>&1
      if [[ "$delay" -gt 0 ]]; then
        sleep "$delay"
        printf '\e[A\e[K'
      fi
    fi
 else
    diehard "$USER is not a member of the sudo group. Access denied." "This incident will be reported to Big Brother."
  fi
}
```
### Notes
- Once the password is entered, the prompt line is blanked out after X seconds.
- If the user is not in the sudo group, an error message is displayed and the calling script exits.
- A delay of 0 bypasses the delay. The password prompt line is not blanked and the script continues.
