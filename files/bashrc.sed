# Bash history modifications
/executed by bash(1)/{x;p;x}
# History control
/HISTCONTROL/ {
s/^/# /
a HISTCONTROL=erasedups:ignorespace
}
/append to the history file/ {
i # set format for time in bash history
i HISTTIMEFORMAT="%Y-%m-%d %T "
{x;p;x}
}
# Aliases
s/ls --color=auto/ls -F --color=auto --group-directories-first/
/#alias grep/s/#//
/#alias fgrep/s/#//
/#alias egrep/s/#//
/^#alias/s/#//
s/ls -alF/ls -alhF --time-style=long-iso/
s/ls -A/ls -AF/
