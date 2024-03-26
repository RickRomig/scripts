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
${bar,,[AEIOU]}	# Make all instances of desiginated letter lowercase
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
	declare -F	# restrict display to function names only (plus line number & source file when debuggigng)
	declare -g	# create global variables when used in a shell function; otherwise ignore
	declare -I	# if creating a local varibable, inherit attributes and value	of a variable with the same name at a previous scope
	declare -p	# display the attributes and values of each NAME
	```
- Options which set attributed:
	```bash
	declare -a	# makes NAMEs indexed arrays (if supported)
	declare -A	# makes NAMEs associative arrays (if supported)
	declare -i	# makes NAMEs have the 'integer' attribute
	declare -l	# convert the value of each NAME to lower case on assignment
	declare -n	# make NAME a reference to the variable named by its value
	declare -r	# make NAMEs readonly
	declare -t	# make NAMEs have the 'trace' attribute
	declare -u	# conver the value of each NMAE to upper case on assignment
	declare -x	# make the NAMEs export
	```
Uing `+` instead of `-` turns off the given attribute.