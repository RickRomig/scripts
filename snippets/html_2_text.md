# Converting HTLM to text

### Remove html tags
```bash
wget -qO- "https://website.com/page" | sed -e 's/<[^>]*>//g'
```
### Convert html to text
```bash
wget -qO- "https://website.com/page" | sed -e 's/<[^>]*>//g'|recode html..ascii
wget -qO- "https://website.com/page" | sed -e 's/<[^>]*>//g'|recode html
w3m -dump "https://website.com/page"
site="$(wget -qO- "https://website.com/page")"; echo "$site"|w3m -dump -T text/html
wget -qO- "https://website.com/page" |  html2text
site="$(wget -qO- "https://website.com/page")"; echo "$site"|html2text
```

### Applications
```bash
sudo apt install recode
sudo apt install w3m
sudo apt install html2text
```
