# Here Docs

### Standard format
```bash
cate << EOF
foo
	bar
	baz
EOF
```
### Ignore initial tab characters
```bash
cat <<- EOF
foo
  bar
	baz
	EOF
```
### With variables
```bash
foo="$1"
cat <<-EOF
$USER is $foo
on $(uname -n)
EOF
```
### Literal output
```bash
foo=$1
cat <<-"EOF"
$USER is $foo
on $(uname -n)
EOF
```
### With pipes
```bash
cat <<- EOF | nl | grep bar | tail
	foo
	bar
	baz
	bar
EOF
```
## Here Strings
### Standard format
```bash
cat <<< 'This is a string.'
```
### Using variables
```bash
input="This is a variable for $USER"
cat <<< "$input"
```
### Read into variables
```bash
read -r a b c <<<"foo bar baz"
echo "a is $a"
echo "b is $b"
echo "c is $c"
```
### Using functions
```bash
my_func() {
	while read -r line; do
		echo "my_func: $line"
	done
}
my_func <<< $'This is one line.'
my_func <<< $'This is\ntwo lines.'
```

