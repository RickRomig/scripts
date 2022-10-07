# Cleans up update weekly update log file
/Reading database/d
/Updating/ {
s/\r/\n/
d
}
/Installing [[:digit:]]/d
/Uninstalling/ {
s/\r/\n/
d
}
