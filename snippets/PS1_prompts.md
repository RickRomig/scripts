# PS1 proompts
## Current PS1 from .bashrc
```bash
# parse git branch in prompt
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# variables:
	BRACKET_COLOR="\[\033[38;5;35m\]"
	CLOCK_COLOR="\[\033[38;5;35m\]"
	JOB_COLOR="\[\033[38;5;33m\]"
	PATH_COLOR="\[\033[38;5;33m\]"
	GIT_COLOR="\[\033[38;5;37m\]"
	LINE_BOTTOM="\342\224\200"
	LINE_BOTTOM_CORNER="\342\224\224"
	LINE_COLOR="\[\033[38;5;248m\]"
	LINE_STRAIGHT="\342\224\200"
	LINE_UPPER_CORNER="\342\224\214"
	END_CHARACTER="|"

	[[ "$SSH_CLIENT" ]] && ssh_msg=" (SSH)"
tty -s && export PS1="$LINE_COLOR$LINE_UPPER_CORNER$LINE_STRAIGHT$LINE_STRAIGHT$BRACKET_COLOR[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[$JOB_COLOR\j$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[\H${ssh_msg}:\]$PATH_COLOR\w$GIT_COLOR\$(parse_git_branch)$BRACKET_COLOR]\n$LINE_COLOR$LINE_BOTTOM_CORNER$LINE_STRAIGHT$LINE_BOTTOM$END_CHARACTER\[$(tput sgr0)\] "
```
## Current PS1
```bash
\[\e]133;k;start_kitty\a\]\[\e]133;A\a\]\[\e]133;k;end_kitty\a\]\[\e]0;\u@\h \w\a\]\[\033[38;5;248m\]\342\224\214\342\224\200\342\224\200\[\033[38;5;35m\][\[\033[38;5;35m\]\t\[\033[38;5;35m\]]\[\033[38;5;248m\]\342\224\200\[\033[38;5;35m\][\[\033[38;5;33m\]\j\[\033[38;5;35m\]]\[\033[38;5;248m\]\342\224\200\[\033[38;5;35m\][\H:\]\[\033[38;5;33m\]\w\[\033[38;5;37m\]$(parse_git_branch)\[\033[38;5;35m\]]\n\[\e]133;k;start_secondary_kitty\a\]\[\e]133;A;k=s\a\]\[\e]133;k;end_secondary_kitty\a\]\[\033[38;5;248m\]\342\224\224\342\224\200\342\224\200|\[\] \[\e]133;k;start_suffix_kitty\a\]\[\e[5 q\]\[\e]2;\w\a\]\[\e]133;k;end_suffix_kitty\a\]
```

## Jay LaCroix prompt - root user:
```bash
export PS1="\[\e[38;5;35m\]╭─\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;9m\]\t\[\e[m\]\[\e[38;5;35m\])\[\e[m\]\[\e[38;5;35m\]-\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;9m\]\j\[\e[m\]\[\e[38;5;35m\])\[\e[m\]\[\e[38;5;35m\]-\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;9m\]\H\[\e[m\]\[\e[38;5;35m\])\[\e[m\]\[\e[38;5;35m\]-\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;9m\]\w\[\e[m\]\[\e[38;5;35m\])\[\e[m\]\n\[\e[38;5;35m\]╰──💣\[\e[m\] "
```
##  Jay LaCroix prompt - normal user:
```bash
export PS1="\[\e[0m\]\[\e[38;5;35m\]╭─(\[\e[38;5;38m\]\t\[\e[38;5;35m\])-(\[\e[38;5;38m\]\j\[\e[38;5;35m\])-(\[\e[38;5;38m\]\H\[\e[38;5;35m\])-(\[\e[38;5;38m\]\w\[\e[38;5;35m\])\n\[\e[38;5;35m\]╰──🚀 \[\e[0m\]"
```
## Bash prompt generators
1. [Bash Prompt Genorator](https://bash-prompt-generator.org/)
2. [EXPrompt](https://ezprompt.net/)
