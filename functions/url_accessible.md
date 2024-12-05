# url_accessible

1. **Purpose**: Check if a URL is valid and accessible.

2. **Arguments**: A URL address, such as https://google.com

3. **Returns**: TRUE (0) is the URL is accessible, otherwise returns FALSE (0).

### Code
```bash
url_accessible() {
  local url result
  url="$1"
  result=$(curl --head --connect-timeout 8 --max-time 14 --silent --output /dev/null --write-out '%{http_code}' "$url")
  [[ "$result" -eq 200 ]] && return "$TRUE" || return "$FALSE"
}
```
