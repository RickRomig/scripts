# edit_view_quit
### Purpose
Edit or view a file after it's been created by a script.
### Arguments
$1 -> The file to be edited or viewed.
#### Notes
1. Any text editor (vim, emacs, etc.) can be substituted for nano. Default is the editor assidnged to the environmental variablle EDITOR.
2. By default, the script uses `bat` or `batcat` (if installed) to display the contents of the file. Otherwise, it will use `less` or `cat` depending how how many lines are in the file to be read.
3. The `viewtext() function implements `less` or `cat`.
