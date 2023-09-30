# Check arguments - file not now
```bash
if [[ "$#" -eq 0 ]]; then
	echo "Error: No argument passed." >&2; usage; exit 1
elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
	usage; exit
elif [[ ! f "$1"  ]]; then
	echo "Error: $1 not found." >&2; usage; exit 1
else
	filename="$1"
fi
```