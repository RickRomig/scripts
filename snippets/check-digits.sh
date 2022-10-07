#!/usr/bin/env bash
# Check if an argument is all digits.

method1() {
	[[ "$1" =~ ^[0-9]+$ ]] && echo "is all digits" || echo "has non-digits"
}

method2() {
	[[ "$1" =~ [^[:digit:]] ]] && echo "has non-digits" || echo "is all digits"
}

echo "By method 1, $1 $(method1 $1)"
echo "BY method 2, $1 $(method2 $1)"
exit
