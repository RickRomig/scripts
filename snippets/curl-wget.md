# curl and wget

#### Download url to a specific filename
```bash
curl -so <filename> <url>	# filename can include path
wget -qO <filename> <url>	# equivalent to wget -qO - <url> > <filename>
```
#### Download and pipe to another command
```bash
curl -s <trusted-key-url> | sudo apt-key --keyring <keyring-dir/trusted-key>
wget -qO -  <trusted-key-url> | sudo apt-key --keyring <keyring-dir/trusted-key>
curl -s "<trusted-key-url> | sudo apt-key add - 
wget -qO - <trusted-key-url> | sudo apt-key add - 
```
#### Miscellaneous
```bash
wget -O- <url>		# prints to STDOUT
wget -P <directory> <url/file>	# Download file to a directory.

curl -O <filename> <url>	# Saves file as <filename> in the current directory.
curl -#										# displays a progress bar
curl --progress-bar				# displays a progress bar
```