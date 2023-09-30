# Placing commas in long numbers

#### using sed
```bash
echo "1234567890" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
1,234,567,890
shuf -i 1000000000-5000000000 -n 1 | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
4,209,628,978
```
#### using numfmt from core-utils
```bash
numfmt --grouping 1234567890
1,234,567,890
numfmt --g 1234567890
1,234,567,890
echo "1234567890" | numfmt --g
1,234,567,890
$ shuf -i 1000000000-5000000000 -n 1 | numfmt --g
3,277,226,792
```

#### using printf
```bash
printf "%'d\n" 1234567890
1,234,567,890
shuf -i 1000000000-5000000000 -n 1 | 
printf "%'d\n" `shuf -i 1000000000-5000000000 -n 1`
1,250,627,350
```
