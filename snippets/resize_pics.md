# resizes images with imagemagick
```bash
for f in *.jpg; do convert "$f" -resize 800x800 resize/"${f%}"; done

# Changes image compression with imagemagick
convert '*.jpg[800x>]' -quality 80 -set filename:base "%[basename]" "dir/%[filename:base].jpg"
```