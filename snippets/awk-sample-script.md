# awk - sample script
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