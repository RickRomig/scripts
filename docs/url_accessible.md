# url_accessible
### Purpose
Check if a URL is valid and accessible.
### Arguments
A URL address, such as https://google.com
### Returns
TRUE (0) is the URL is accessible, otherwise returns FALSE (1).
### Usage
```bash
url_accessible "https:foobar.com" || die "foobar.com is not accessible" 1
```
### Code
```bash
url_accessible() {
  local url result
  url="$1"
  result=$(curl --head --connect-timeout 8 --max-time 14 --silent --output /dev/null --write-out '%{http_code}' "$url")
  [[ "$result" -eq 200 ]] && return "$TRUE" || return "$FALSE"
}
```
### Notes
