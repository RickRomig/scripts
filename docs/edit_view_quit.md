# edit_view_quit
### Purpose
Edit or view a file after it's been created by a script.
### Arguments
The file to be edited or viewed.
### Code
```bash
edit_view_quit() {
  local filename _opt
  filename="$1"
  printf "\nYou may edit or view %s at this time.\n\n" "$filename"
  PS3="Choose an option: "
  select _opt in Edit View Quit; do
    case "$REPLY" in
      1 )
        if exists micro; then
          /usr/bin/micro "$filename"
        else
          /usr/bin/nano "$filename"
          remove_tilde
        fi
        break
      ;;
      2 )
        if exists batcat; then
          "$HOME"/.local/bin/bat "$filename"
        elif exists bat; then
          /usr/bin/bat "$filename"
        else
          viewtext "$filename"
        fi
        break
      ;;
      3 )
        printf "\nExiting.\n"
        break
      ;;
      * )
        printf "%sInvalid choice. Try again.%s\n" "$orange" "$normal" >&2
    esac
  done
}
```
### Notes
1. Any text editor (vim, emacs, etc.) can be substituted for nano
2. By default, the script uses `bat` or `batcat` (if installed) to display the contents of the file. Otherwise, it will use `less` or `cat` depending how how many lines are in the file to be read.
3. The `viewtext() function implements `less` or `cat`.
