# sudo
### Add your user to the sudo group if you enabled root login druing Debian installation
```bash
su -
/usr/bin/apt install sudo
/usr/bin/getent group sudo 2>&1 > /dev/null || /usr/sbin/groupadd sudo
/usr/sbin/usermod -aG sudo rick
exit
chfn rick    # add room number, phone to user data
```
### Add user to sudo group
```bash
# Choose one method
sudo usermod -aG sudo username
sudo adduser new_username
sudo usradd new_username
sudo passwd new_username
# Test addition
su - new_username
sudo whoami
```
### Change sudo timeout for a user
```bash
# per-user sudo timeout
cd /etc/sudoers.d/
sudo visudo -f rick
	Defaults timestamp_timeout=30
echo "Defaults timestamp_timeout=30" | sudo tee /etc/sudoers.d/rick
```
### Add pwfeeback and timeout from a script
```bash
sudo sh -c 'echo "Defaults pwfeedback" > /etc/sudoers.d/0pwfeedback'
sudo chmod 440 /etc/sudoers.d/0pwfeedback
sudo sh -c 'echo "Defaults timestamp_timeout=30"" > /etc/sudoers.d/rick'
sudo chmod 440 /etc/sudoers.d/rick
```