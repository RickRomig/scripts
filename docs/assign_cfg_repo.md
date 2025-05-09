# assign_cfg_repo

### Purpose
Assign directory containing configs repository or a clone of it for the purpose of linking or copying configuration files.
### Arguments
None
### Returns
Repository path is passed to variable via command subsitution.
### Usage
```bash
$ repository=$(assign_cfg_repo)
```
### Notes
None
### Code
```bash
assign_cfg_repo() {
	local localip repo_dir
	localip=$(local_ip)
	repo_dir="$HOME/Downloads/configs"
	case "$localip" in
		10|16|22 )
			repo_dir="$HOME/gitea/configs" ;;
		* )
			if [[ -d "$repo_dir" ]]; then
				pushd "$repo_dir" || die "pushd failed"
				git pull
				popd || die "popd failed"
			else
				git clone "$GITHUB_URL/configs.git" "$repo_dir/configs"
			fi
			# repo="$repo_dir"
	esac
	printf "%s" "$repo_dir"
}
```
