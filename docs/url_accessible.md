# url_accessible
### Purpose
Check if a URL is valid and accessible.
### Arguments
$1 -> URL to be checked, such as https://google.com
### Returns
TRUE (0) is the URL is accessible, otherwise returns FALSE (1).
### Usage
```bash
url_accessible "https:foobar.com" || die "foobar.com is not accessible" 1
```
### Notes
