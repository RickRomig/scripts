# tar
### Create an archive
```bash
tar -cvzf archive-directory -C "$HOME" source-directory
# incremental or differential archive
tar -cvzg archive-direcotory/snar-file -f archive-directory -C source-directory
```
### List an archive
```bash
tar --list --verbose --verbose --file ./backup/data-1.tar.gz
tar -tvf ./backup/archive_file.tar.gz
# incremental or differential archive
tar --list --incremental --verbose --verbose --file ./backup/data-1.tar.gz
tar -tvg /dev/null -f ./backup/archive_file.tar.gz
```
### Restore an archive
```bash
tar -xvf ./backup/full_archive.tar.gz -g /dev/null		# full backup
tar -xfg /dev/null -f inc_archive.tar.gz							# incremental backup
```

### Extract or restore an archive
```bash
tar -xvf archive_file.tar.gz
```
