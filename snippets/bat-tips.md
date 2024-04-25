# Bat Tips
### Display the contents of mulitiple files
```bash
bat dir/*.c
```
### Display with syntax highlighting for languate
```bash
bat -l json file
bat --language=json file
```
### Display non-printable characters
```bash
bat -A
```
### `fzf` preview
```bash
fzf --preview "bat --color=always --style=numbers -- line-range=400 {}"
```
### `find`
```bash
find... -exec bat {} +
```
### `git`
```bash
git show v0.6.0:src/main.c | bat -l c
batdiff() {
  git diff --name-only --relative --diff-filtered | xargs bat --diff
}
```
### `man`
- Add the following to `.bashrc`
  ```bash
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  man 2 select
  # if `batman` bat-extra is installed:
  alias man='batman'
  ```
- If Debian and Ubuntu, use `batcat`
### With `--help`
```bash
cp --help | bat -plhelp
# Wrapper in .bash_aliases
alias bathelp='bat --plain --language=help'
help() {
  "$@" --help 2>&1 | bathelp
}
$ help cp
$ help git commit
```
