# assign_cfg_repo

### Purpose
Assign directory containing configs repository or a clone of it for the purpose of linking or copying configuration files.
### Arguments
None
### Returns
Repository path is passed to variable via command subsitution.
### Usage
```bash
repository=$(assign_cfg_repo)
```
### Notes
None
### Code
```bash
assign_cfg_repo() {
	local local_host repo_dir
	local_host="${HOSTNAME:-$(hostname)}"
	repo_dir="$HOME/Downloads/configs"
	case "$local_host" in
		hp-800g2-sff|hp-8300-usdt|hp-850-g3 )
			repo_dir="$HOME/gitea/configs" ;;
		* )
			if [[ -d "$repo_dir" ]]; then
				pushd "$repo_dir" || die "pushd failed"
				git pull --quiet
				popd || die "popd failed"
			else
				git clone --quiet "$GITHUB_URL/configs.git" "$repo_dir/configs"
			fi
	esac
	printf "%s" "$repo_dir"
}
```
