# Cleans up update weekly update log file
/Reading database/d
# From flatpak
/Updating/ {
s/\r/\n/
d
}
/Installing [[:digit:]]/d
/Uninstalling/ {
s/\r/\n/
d
}
# Deleting warnings if nala installed.
/W: Target/d
