# Awk Tips & Tricks
## awk - sample script
```bash
count.awk
BEGIN {
	print "Log access to web server"
}
{ ip[$1] ++ }
END {
	for i in ip
	pirnt i "has accessed ", ip[i], " times."
}

awk -f count.awk /var/log/nginx/access.log.1
```
## Match pattern in a variable in awk
You can't use the variable inside the regex // notation (there's no way to distinguish it from searching for pat); you have to specify that the variable is a regex with the ~ (matching) operator.
```bash
awk -v pat="$pattern" -F":" '$0 ~ pat { print $1, $2, $3, $4 }' sample_profile.txt
```
