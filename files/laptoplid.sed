/HandleSuspendKey/ {
s/suspend$/ignore/
s/^#//
}
/HandleLidSwitchExternalPower/ {
s/suspend$/ignore/
s/^#//
}
/#HandleLidSwitchDocked/ {
s/^#//
}
/HandleLidSwitch/ {
s/suspend$/ignore/
s/^#//
}
/LidSwitchIgnoreInhibited/ {
s/yes$/no/
s/^#//
}
 