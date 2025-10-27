# Copy/Link Config Files
### Function for copying config.confs from cloned repositories
``` bash
application_config() {
  local repository=~/Downloads/ccnfigs/config_dir
  [[ -d ~/gitea/configs/config_dir ]] && repository=~/gitea/configs/config_dir/
  if ! [[ -d "$repository" ]]; then
    printf "%s Cloned repository not found!\n" "$RED_WARNING" >&2
    return
  fi
  [[ -d ~/.config/config_dir ]] || mkdir -p ~/.config/config_dir
  printf "Applying configuration files ...\n"
  cp -v "$repository"/config.conf ~/.config/config_dir/
  printf "Application configuration files applied.\n"
}
```
### Function for linking config.confs from cloned repositories
``` bash
application_config() {
  printf "Applying Bat configuration...\n"
	[[ -d ~/.config/config_dir ]] || mkdir -p ~/.config/config_dir
	if [[ ! -d ~/Downloads/configs && ! -d ~/gitea/configs ]]; then
		printf "%s Cloned repository not found!\n" "$RED_WARNING" >&2
		return
	fi
	[[ -f ~/.config/config_dir/config.conf ]] && rm ~/.config/config_dir/config.conf
  [[ -d ~/gitea/configs ]] && ln -sv ~/gitea/configs/config_dir/config.conf ~/.config/config_dir/config.conf
	[[ -d ~/Downloads/configs ]] && ln -sv ~/Downloads/configs/config_dir/config.conf ~/.config/config_dir/config.conf
  printf "Application configuration files applied.\n"
}
```
### Remove app directories
Remove application sudirectories in .config/, .cache/. .local/
```bash
remove_cfg_folers() {
  find ~/ -maxdepth 3 -type d -path "$HOME/Downloads" -prune -o -path "$HOME/gitea" -prune -o -type d -name application -exec rm -rf {} \;
  # test command
  find ~/ -maxdepth 3 -type d -path "$HOME/Downloads" -prune -o -path "$HOME/gitea" -prune -o -type d -name application -print
}
```
### IRU scripts
```bash
# check if new_ver is an empty string in compare_versions or install functions
  if [[ -z "$new_ver" ]]; then
    printf "No download available. Try again later." >&2
    return
  fi
```
