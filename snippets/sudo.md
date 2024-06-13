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
```