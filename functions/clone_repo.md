# clone_repo

1. **Purpose:** Clones a repository from the GitHub or Gitea server to the `~/Downloads` directory.

2. **Arguments:**

   - `$1` - The basename of the reposiitory to be cloned.

3. **Notes:**

   - The URLs of the Git servers are set in functionlib.

   - The .git extension is automatically appended to the repository name by the function.

```bash
clone_repo() {
   local git_repo="${1}.git"
   local url
   case "$git_repo" in
      configs|scripts|i3wm-debian )
         url="$GITHUB_URL" ;;
      * )
         url="$GITEA_URL"
   esac
   git clone "$url/$git_repo" "$HOME/Downloads"
}
```
