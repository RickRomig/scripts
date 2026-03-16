# whitespace.md

## Leading & trailing whitespaces
1. **xargs**
```bash
$ echo "     foo bar   baz  " | xargs
foo bar baz
```
2. **tr**
```bash
$ echo " foo bar   baz " | tr -d '[:blank:]'	# the -d flag deletes all occurrences of a character.
foobarbaz
$ echo " foo bar   baz " | tr -d '[:space:]'	# removes newlines
foobarbaz
$ echo " foo bar   baz " | tr -s '[:blank:]'	# removes sequential characters
 foo bar baz
$ str="  Hello     world!"
$$ trim_str="$(echo "$str" | tr -d " ")"
$ echo "Trimmed string: $trim_str"
Helloworld!
$ str="  Hello     world!"
$ trim_str="$(echo "$str" | tr -s " ")"
$ echo "Trimmed string: $trim_str"
Hello world!
```
3. **sed**
```bash
echo " foo bar   baz " | sed 's/[[:blank:]]//g'
foobarbaz
$ echo " foo bar   baz " | sed -r 's/[[:blank:]]+/ /g'	# -r = extended regular expression
 foo bar baz
$ echo " foo bar   baz " | sed -re 's/^[[:blank:]]+|[[:blank:]]+$//g' -e 's/[[:blank:]]+/ /g'
foo bar baz
```
4. Built-in String Manipulation
```bash
$ var="ababc"
$ echo "${var#a*b}"
abc
$ var="ababc"
$ echo "${var##a*b}"
c
$ var="ababc"
$ echo "${var%b*c}"
aba
$ echo "${var%%b*c}"
a
$ var=" welcome to    mosfanet "
$ var="${var"${var%%[![:space:]]*}"}"
$ echo "$var"
welcome to    mosfanet
$ var="${var#"${var%%[![:space:]]*}"}"	# leading whitespace
echo "$var"
welcome to    mosfanet
$ var="${var%"${var##*[![:space:]]}"}" ; echo "$var"  # trailing whitespace
$ echo "$var"
welcome to    mosfanet
```
5. **awk**
```bash
#!/bin/bash

str="  Hello     world!"
echo "Untrimmed string: $str"

trim_str="$(awk '{$1=$1}1' <<< "$str")"
echo "Trimmed string: $trim_str"
Hello world!
$ awk -i inplace '{$1=$1}1' textfile
# modifies the file inplace, all leading, trailing, & space between words trimmed
```
