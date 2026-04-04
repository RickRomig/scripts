# clone_repo
### Purpose
Clones a repository from the GitHub or Gitea server to the `~/Downloads` directory.
### Argument
$1 -> The basename of the reposiitory to be cloned.
### Dependencies
git
### Usage
```bash
clone_repo scripts
```
### Notes
- The URLs of the Git servers are set in functionlib.
- The .git extension is automatically appended to the repository name by the function.
