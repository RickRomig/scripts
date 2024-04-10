# simple random password generator
```bash
cat /dev/urandom | tr -dc '[:alnum:][:punct:]' | head -c 16; echo
```
