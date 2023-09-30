# Top 10 history commands
```bash
# Normally, {print $3}. Use {print $5} if HISTTIMEFORMAT is set to include date and time.
history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $5}' | sort | uniq -c | sort -nr | head -10
# All history counts
history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $5}' | sort | uniq -c | sort -nr
```
#### .bashrc history settings
```bash
HISTCONTROL=erasedups:ignorespace
#### set format for time in bash history
```bash
HISTTIMEFORMAT="%Y-%m-%d %T "
```
#### Set .bash_logout to clean up .bash_history
```bash
history -a && history -c && sort -u -o ~/.bash_history ~/.bash_history && history -r
```
