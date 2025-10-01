# Alias functions
## ~/.bash_aliases

#### Check if a program is installed
```bash
exist() {
  command -v "$1" > /dev/null && echo "$1 installed" || echo "$1 not installed"
}
exist foobar
```
#### Check if a package is in distribution repositories.
```bash
inrepos() {
  pkg=$(apt-cache show "$1" 2>/dev/null | awk '/Package:/ {print $NF}')
  [[ "$pkg" ]] && echo "$1 found in repos" || echo "$1 not found in repos"
}
```
#### Get a future date a given number of days from the current date
```bash
future() {
  echo "$1 days from now will be $(date -d "$(date +%y-%m-%d) + $1 days" +"%d %b %Y")"
}
future 90
```
#### Kill stopped jobs
```bash
killjobs() {
  kill -9 $(jobs -ps)
}
killjobs
```
#### Remove files ending with a tilde in the current directory
```bash
rm~() {
  find ./ -maxdepth 1 -type f -regex '\./.*~$' -print -exec rm {} \;
}
rm~
```
#### Change directories and list its contents in one command
```bash
cdls() {
  local dir="${1:-$HOME}"
  if [[ -d "$dir" ]]; then
    cd "$dir" >/dev/null; ls -CF --group-directories-first --color=auto
  else
    echo "bash: cdls: $dir: Directory not found"
  fi
}
cdls .config
```
#### Move up a specified number of directories (i.e. `up 4` moves up 4 directory levels.)
```bash
up() {
	local d=""
	limit=$1
	for ((i = 1; i <= limit; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}
up 4
```
#### Copy with a progress bar.
```bash
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}
cpp foobar foo/bar
```
#### Copy a file to another directory and change to that directory in one command
```bash
cpcd (){
  if [ -d "$2" ]; then
    cp $1 $2 && cd $2
  else
    cp $1 $2
  fi
}
cpcd foobar foo/bar
```
#### Move a file to another directory and change to that directory in one command
```bash
mvcd (){
  if [ -d "$2" ]; then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}
mvcd foobar foo/bar
```
#### Create a directory and cd into it
```bash
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}
mkcd foobar
```
#### Copy a text file to multiple systems using DSH.
```bash
# $1 = filename $2 = dsh group $3 = target directory on remote host
dcp() {
	  cat "$1" | dsh -g "$2" -i -c "tee $3/$(basename "$1")"
  }
dcp foo group path/on/remote/systems
```
#### Execute a command to a group of remote hosts using DSH.
```bash
# $1 = dsh group name, $2 = command (in quotes)
dsh-grp() {
	dsh -M -g $1 -c $2
}
dsh-grp laptops "foobar"
```
#### Execute a command on a remote host via SSH.
```bash
# $1 = last octet of IP, $2= 'command' (scripts should be prefessed by bin/)
ssh-cmd() {
	ssh 192.168.0."$1" "$2"
}
ssh-cmd 20 bin/foobar.sh
```
#### Decrypt an encrytped pdf file
```bash
decryptpdf() {
	qpdf --password="$1" --decrypt "$2".pdf --replace-input
}
decryptpdf 3287 foobar.pdf
```
#### Add a file to be staged in git and create a commit for it
```bash
gcommit() {
	git status
	git add $1
	git commit -m "$1 - $2"
}
gcommit foo.bar "Made some changes to foo.bar" && gpush
```
#### Add all new or modified files to be staged in git and create a commit
```bash
gcommitall() {
	git status
	git add -A
	git commit -m "$1"
}
gcommitall "Changed some files." && gpush
```
#### Add a file to be staged in git and create a command for it without verifying the code
```bash
ncommit() {
	git status
	git add $1
	git commit -m "$1 - $2" --no-verify
}
ncommit foo.bar "Made some changes to foo.bar" && gpush
```
#### Add all new or modified files in git and create a command for it without verifying the code
```bash
ncommitall() {
	git status
	git add -A
	git commit -m "$1" --no-verify
}
ncommitall "Changed some files." && gpush
```
#### Extract compressed files using various compression utilitiesl.
```bash
ex () {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz )    tar xjf $1  ;;
      *.tar.gz )    tar xzf $1  ;;
      *.bz2 )       bunzip2 $1  ;;
      *.rar )       unrar  $1   ;;
      *.gz )        gunzip $1   ;;
      *.tar )       tar xf $1   ;;
      *.tbz2 )      tar xjf $1  ;;
      *.tgz )       tar xzf $1  ;;
      *.zip )       unzip $1    ;;
      *.Z )         uncompress $1 ;;
      *.7z )        7z x $1     ;;
      *.deb )       ar x $1     ;;
      *.tar.xz )    tar xf $1   ;;
      *.tar.zst )   unzstd $1   ;;
      * )           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file."
  fi
}
ex foobar.tar.gz
```
#### `bat` help wrapper for syntax highlighting with --help (requres `bat` to be installed)
```bash
alias bathelp='bat --plain --language=help'
help() {
  "$@" --help 2>&1 | bathelp
}
help htop
```
#### Online cheatsheet for Linux commands
cheat() {
  curl -s cheat.sh/$1 | bat -p
}
#### Display timeshift snapshots on the command line.
```bash
tsl() {
	if dpkg -l timeshift >/dev/null 2>&1; then sudo timeshift --list | awk 'NR!=1 && NR!=3'; else echo "Timeshift not installed."; fi
}
tsl
```
#### Use `fzf` to list and search for files in the current directory and select a file to be edited by `micro`.
```bash
micro-file() {
	file=$(find . -type f | sort -d | fzf --reverse --preview="bat --style=full --color=always {}" --bind shift-up:preview-page-up,shift-down:preview-page-down --border=rounded)
	[[ "$file" ]] && micro "$file"
}
micro-file
```
#### awk field separator....?
field() {
  awk -F "${2:- }" "{print \$${1:-1} }"
}
#### Restore files from the trash directory
```bash
restore-trash() { /usr/bin/trash-restore $1; }
```
### .bashrc alias functions
#### Parse git branch, identifies git branch in bash prompt (~/.bashrc)
  ```bash
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }
```
#### Alias for ssh if terminal is kitty (.bashrc)
```bash
[[ "$TERM" = "xterm-kitty" ]] && alias ssh="kitty +kitten ssh"
```
