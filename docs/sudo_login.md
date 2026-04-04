# sudo_login
### Purpose
Prompts for the sudo password if user is in the sudo group and there is not an active sudo session.
### Arguments
$1 -> number of seconds to sleep before blanking the prompt line and the script contintues. If delay is 0, line is immediately blanked.
### Returns
Nothing
### Usage
```bash
sudo_login 2
```
### Notes
- Once the password is entered, the prompt line is blanked out after X seconds.
- If the user is not in the sudo group, an error message is displayed and the calling script exits.
