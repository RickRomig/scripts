# Converting variables upper and lower case
#### Capitalizing variables
```bash
foo="nullifidian - non fractus, non perditus, non ovis."
${foo^}				# Capitalize 1st letter of the string
Nullifidian - non fractus, non perditus, non ovis.
${foo^n}			# Capitalize 1st letter of the string if it's an 'n'
Nullifidian - non fractus, non perditus, non ovis.
${foo^[n]}		# Capitalize 1st letter of the string if it's an 'n'
Nullifidian - non fractus, non perditus, non ovis.
${foo^^}			# Capitallze all letters
NULLIFIDIAN - NON FRACTUS, NON PERDITUS, NON OVIS.
${foo^^f}			# Capitalize all instances of a letter, nuLLifidian
nulliFidian - non Fractus, non perditus, non ovis.
${foo^^[u]}		# Capitalize all instances of the designated letter
nUllifidian - non fractUs, non perditUs, non ovis.
${foo^^[aeiou]}	# Capitalize all instances of the designated letters
nUllIfIdIAn - nOn frActUs, nOn pErdItUs, nOn OvIs.
```
#### Lowercase variables
```bash
bar="NULLIFIDIAN - NON FRACTUS, NON PERDITUS, NON OVIS."
${bar,}				# Make 1st letter lowercase of the string
nULLIFIDIAN - NON FRACTUS, NON PERDITUS, NON OVIS.
${bar,N}			# Make 1st letter lowercase of the string if it's an 'N'
nULLIFIDIAN - NON FRACTUS, NON PERDITUS, NON OVIS.
${bar,[N]}		# Make 1st letter lowercase of the string if it's an 'N'
nULLIFIDIAN - NON FRACTUS, NON PERDITUS, NON OVIS.
${bar,,}			# Make all letters lowercase
nullifidian - non fractus, non perditus, non ovis.
${bar,,[I]}		# Make all instances of a letter lowercase
NULLiFiDiAN - NON FRACTUS, NON PERDiTUS, NON OViS.
${bar,,[AEIOU]}	# Make all instances of designated letter lowercase
NuLLiFiDiaN - NoN FRaCTuS, NoN PeRDiTuS, NoN oViS.
```

#### Using the tr command
```bash
foo="$(tr '[:lower:]' '[:upper:]' <<< ${foo:0:1})${foo:1}"
```

#### Using the sed command
```bash
foo=$(echo "$foo" | sed 's/^./\U&\E/')	# convert 1st letter to uppercase
echo "$(echo "$foo" | sed 's/.*/\U&/')"		# convert all letters to uppercase
echo "$(echo "foo" | sed 's/^[^ ]*/\U&\E/'	# convert 1st word to uppercase
# Replace U with L to make lowercase.
# \E = leave all preceding characters in their current state
```

#### Capitalize user's name
```bash
echo "Hello ${USER^}. I am $(uname -n), your computer."
printf "Hello %s. I am %s, your computer.\n" "${USER^}" "$(uname -n)"
```

#### Using parameter expansion to change characters in a string
Syntax `${variable//search/replace}`
```bash
string="stirng" ; echo "$string" | sed -e "s/ir/ri/"	# Problematic code
string="stirng" ; echo "${string//ir/ri}"	# Correct code
```
#### Variable delarations
Using the declare command in a function makes the variable local to the function (`-g` suppress it).
- Options:
	```bash
	declare -f	# restrict action or display to function names and definitions
	declare -F	# restrict display to function names only (plus line number & source file when debugging)
	declare -g	# create global variables when used in a shell function; otherwise ignore
	declare -I	# if creating a local varibable, inherit attributes and value	of a variable with the same name at a previous scope
	declare -p	# display the attributes and values of each NAME
	```
- Options which set attributes:
	```bash
	declare -a	# makes NAMEs indexed arrays (if supported)
	declare -A	# makes NAMEs associative arrays (if supported)
	declare -i	# makes NAMEs have the 'integer' attribute
	declare -l	# convert the value of each NAME to lower case on assignment
	declare -n	# make NAME a reference to the variable named by its value
	declare -r	# make NAMEs readonly
	declare -t	# make NAMEs have the 'trace' attribute
	declare -u	# convert the value of each NAME to upper case on assignment
	declare -x	# make the NAMEs export
	```
Using `+` instead of `-` turns off the given attribute.
#### Check if variable is all digits:
```bash
[[ "$value" =~ ^[0-9]+$ ]] && echo "digits" || echo "non-digits"	# true if all digits
[[ "$value" =~ [^[:digit:]] ]] && echo "non-digits" || echo "digits"
[[ "${value//[0-9]/}" ]] || && echo "non-digits" || echo "digits"	# strips out digits and returns true if there's anything left
```
#### Place commas in numbers:
```bash
printf "%'d\n" 123456789
123,456,789
echo "123456789" | awk '{printf "%\'d\n", $1}'
123,456,789
echo "123456789" | sed ':a;s/\B[0-9]\{3\}/,&/;ta'
123,456,789
```
#### Base and directory names
- Get the basename of a file:
```bash
$ echo "$(basename "$filepath")
$ echo "${filepath##*/}"
$ script=$(basename "$0")
$ script="${0##*/}"
```
- Get the directory path of a file:
```bash
$ echo "$(dirname "$filepath")		# displays . or .. [/directory] (full path if not $PWD or subdirectory )
$ echo "${filepath%/*}			# displays full path
$ script_dir=$(dirname "$(readlink -f "${0}")")			# displays full path
$ script_dir=$(dirname "$0")		# displays . or .. [/directory] (full path if not $PWD or subdirectory )
$ script_dir="${0%/*}"		# displays . or .. [/directory] (full path if not $PWD or subdirectory )
```
### Arrays
1. Indexed arrays
	- Declaring indexed arrays:
```bash
$ declare -a arr
$ arr=()
$ arr=(foo bar baz)
```
	- Accessing the array:
```bash
$ echo "${arr[*]}"
foo bar baz
$ echo "${arr[@]}"
foo bar baz
$ printf "<%s>\n" "${arr[*]}"	# '*' stringifies the elements of the array
<foo bar baz>
foo bar baz
$ printf "<%s>\n" "${arr[@]}"	# '@' interates the elements of the array
<foo>
<bar>
<baz>
```
	- Should always use quotes and {} brackets when accessing array elements.
2. Associative arrays
	- Declaring associative arrays:
```bash
$ declare -A arr
$ declare -A arr || exit 1	# test to see if your version bash supports associative arrays
```
	- Assigning keys and elements to associative arrays:
```bash

```
	- Accessing associative arrays:
```bash

```
