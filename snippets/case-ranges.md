# case - using ranges
```bash
case $var in
	[0-9]? | ? )
		echo "Any digit followed by any single character or any single character"
	;;
	[1-6]* | ? )
		echo "A digit (1-6) followed by any character or any single character"
	;;
	[7-8]? )
		echo "7 or 8, followed by a single character"
	;;
	9[0-9] )
		echo "9 followed by 0-9"
esac
```
