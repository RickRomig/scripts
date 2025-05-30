# Copying fonts from either sshfs or vm host.
```bash
copy-font() {
  font_dir=$HOME"/.local/share/fonts"
  font="Cascadia.ttf"
  [[ -d "$font_dir" ]] || mkdir -p "$font_dir"
  if [[ $"localnet" == "192.168.0" ]]; then
    [[ -f "$font_dir/$font" ]] || cp -pv "$font_src/$font" "$font_dir/"
    printf "$s font copied to %s\n" "$font" "$font_dir"
  elif [[ $"localnet" == "192.168.122" ]]; then
    scp rick@192.168.122.1:.local/share/fonts/Cascadia.ttf "$font_dir"
    printf "$s font copied to %s\n" "$font" "$font_dir"
  else
    printf "%s font is not available.\n" "$font"
  fi
}

copy-font_vm() {
	font_dir=$HOME"/.local/share/fonts"
  font="Cascadia.ttf"
  [[ -d "$font_dir" ]] || mkdir -p "$font_dir"
	[[ $"localnet" == "192.168.122" ]] && scp rick@192.168.122.1:.local/share/fonts/Cascadia.ttf "$font_dir"
	printf "$s font copied to %s\n" "$font" "$font_dir"
}
```

Ideally, Cascadia fonts should already be installed from install-fonts script.
`/usr/share/fonts/truetype/cascadia-code`

On a VM copying Cascadia.ttf to `~/.local/share/fonts/` from the host computer should be sufficient.
