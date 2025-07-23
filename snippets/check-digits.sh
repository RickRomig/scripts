#!/usr/bin/env bash
# Check if an argument is all digits.

method1() {
	[[ "$1" =~ ^[0-9]+$ ]] && echo "is all digits" || echo "has non-digits"
}

method2() {
	[[ "$1" =~ [^[:digit:]] ]] && echo "has non-digits" || echo "is all digits"
}

method3() {
	[[ "${1//[0-9]/}" ]] && echo "has non-digits" || echo "is all digits"
}

main() {
	echo "By method 1, $1 $(method1 "$1")"
	echo "BY method 2, $1 $(method2 "$1")"
	echo "BY method 3, $1 $(method3 "$1")"
	exit
}

main "$@"
