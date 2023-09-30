# Renaming multiple files.
```bash
$ seq 10 | xargs -I {} touch {}.txt
$ seq 10 | xargs -I {} touch foo{}.txt

$ for x in *.txt; do mv -- "$x" "${x%.txt}.text"; done

$ find . -name "*.text" -exec sh -c 'x="{}"; mv -- "$x" "${x%.text}.txt"' \;

$ rename 's/foo/bar/' *.txt
$ rename 'y/a-z/A-Z/' *.txt
```