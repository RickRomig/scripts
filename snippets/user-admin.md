# User Administration

### Commands to create a new user
```bash
sudo adduser <username>			# Adds user using defaults contained in /etc/default/useradd
sudo adduser -m <username>		# add user and create home folder
sudo adduser -r	<username>		# create a system user
# create user with a home directory, set default shell, with comment with first and last name
sudo adduser -m -s /bin/bash -c "Firstname Lastname" <username>
```
### Command to set user's password
```bash
sudo passwd <username>	# user can change his password with passwd command alone
```
### Commands to remove a user
```bash
userdel <username>		# delete user but keep home directory
userdel -r <username>	# delete user and his home directory
```
### Other commands to administer a user's account
```bash
sudo passwd -l <username>
# Unlock a user account
sudo passed -u <username>
# Set an expiration date for a user account
sudo chage -E 2021-12-21 <username>
# Set number of days that a password is valid
sudo chage -M 30 <username>		# Password is valid for 30 days
sudo chage -M -1 <username>		# Password never expires
# set minimum number of days between password changes
sudo chage -m 7 <username>		# User must wait at least 7 days between password changes.
# list expiration settings for user
sudo chage -l <username>
```
