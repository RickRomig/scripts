# Add OpenGPG repository signing key and sources.list file

# Global variables:
readonly keyring_dir="/usr/share/keyrings"
readonly sources_list="/etc/apt/sources.list.d/<repo>.list"
readonly trusted_key="<repo>-archive-keyring.gpg"

# Local variables in install function
local trusted_key_url="https://<repository-url>.gpg"
local sources_list_url="https://<repository-url> any main"

# Add OpenGPG repository signing key
wget -O- "$trusted_key_url" | gpg --dearmor | sudo tee "$keyring_dir/$trusted_key"

# Add sources.list file
echo "deb [arch=amd64 signed-by=$keyring_dir/$trusted_key] $sources_list_url" | sudo tee "$sources_list"
# Add source repo
echo "deb-src $sources_list_url" | sudo tee -a "$sources_list"

# Removing key and sources.list files
[[ -f "$keyring_dir/$trusted_key" ]] && sudo rm "$keyring_dir/$trusted_key"
[[ -f "$sources_list" ]] && sudo rm "$sources_list"
# Removal from /etc/apt/trusted.gpg will have to be done manually
# sudo apt-key del <KEY-ID>
