/atblanks/ s/^# //
/autoindent/ s/^# //
/set backup/ s/^# //
/linenumbers/ s/^# //
/set nowrap/ s/^set/# set/
/set mouse/ s/^# //
/softwrap/ s/^# //
/tabsize/ {
s/8/4/
s/^# //
}
/tabstospaces/ s/^set /# set/
/miinbar/ s/^# //
/saveonexit/ s/^# //
/bind \^Q/ s/^#//
/bind \^F/ s/^#//
/bind \^X/ s/^#//
/bind \^C/ s/^#//
/bind \^V/ s/^#//
