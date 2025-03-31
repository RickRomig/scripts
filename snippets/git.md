# Git information

### GitHub - ssh access

```bash
$ cd ~/.ssh
$ eval "$(ssh-agent -s)"
Agent pid 196089
$ ssh-add ~/.ssh/id_rsa
Identity added: /home/rick/.ssh/id_rsa (rick@hp-800g2-sff)
$ cat id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPrk7K2eHhnoDpUirtyLn2P5498PyD63lenR64/tG0CnZm873pTAKr8MpAmluz8uOTm1+hdyFBN7DT8YyJiliUqC3YaBxVPqhgA3Dfe/cIcOIdhNzBawqqQSljXaBBUkpxmom9lf+8FPSaql/+/rg7/yhsur18AoS92X2eavGKeNbafOsHnMWYsO6dtOOBEl54+NJwFG0XYvFACnFQlksv2hjkuj25V3AdD6znvVfka5aBcWT93K0weWZWbugDtUxsokz1tmER5PwTlkZfReRQh4kLzejogg/hOF7nD2tzbSkKLpz9PUotp28ocuSFGLYePA7apMUu6csiQ5Hry8v1QQlhRwlPyygoSnRf4S6A7LNzDb+VD65ClW7XAVIzkyknbhIRX+XwJ25IbNQ68CMhBNLHJfjpNx51EldEYpx5RNjFDJZhQWSMV9tH8yDQ5fZYWgV7VyqnVBfET3FFUH+6q1B49Q1NBApYnXa1XN1Vs492AI3/bfP48P2XZfsHNTc= rick@hp-800g2-sff
```

**Check SSH connection:**
`ssh git@ssh.github.com`
**Set remote to use SSH:**
`git remote set-url origin git@github.com:RickRomig/<repo>.git`
**Set the remote asupstream origin master:**
`git push --set-upstream origin master`

### Check if you are in a git working directory
```bast
git rev-parse --is-inside-work-tree
```
- Prints 'true' to STDOUT if you are in a git repos working tree.
- Returns output to STDERR if you are outside of a git repo (and does not print 'false').
