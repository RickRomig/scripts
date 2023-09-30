# Create a script configuration file

#### Function to create the configuation file
```bash
readonly conf_dir="$HOME/.config/scripts"
readonly conf_file="$_script.conf"

create_conf() {
  [[ -d "$conf_dir" ]] || mkdir -p "$conf_dir"
  echo "Complete all fields"
  read -rp "Main hostname: " main_host
  read -rp "IP address (last octect): " main_ip
  read -rp "Laptop hostname: " lap_host
  read -rp "IP adddress (last octet): " lap_ip
  read -rp "Wireless IP (last octet): " wifi_ip

  echo "
  main_host='$main_host'
  main_ip='$main_ip'
  lap_host='$lap_host'
  lap_ip='$lap_ip'
  wifi_ip='$wifi_ip'
  " > "$conf_dir/$conf_file"
}
```
#### Call the function
```bash
[[ -f "$conf_dir/$conf_file" ]] || create_conf
source "$conf_dir/$conf_file"
```