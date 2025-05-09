# clone_repo
### Purpose
Clones a repository from the GitHub or Gitea server to the `~/Downloads` directory.
### Arguments
The basename of the reposiitory to be cloned.
### Usage
```bash
clone_repo scripts
```
### Notes
- The URLs of the Git servers are set in functionlib.
- The .git extension is automatically appended to the repository name by the function.
### Code
```bash
clone_repo() {
  local git_repo="$1"
  local url
  case "$git_repo" in
    configs | scripts | i3wm-debian )
      url="$GITHUB_URL" ;;
    * )
      url="$GITEA_URL"
  esac
  git clone "$url/${git_repo}.git" "$HOME/Downloads/$git_repo"
}
```
