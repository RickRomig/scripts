# cleans up youtube-dl update log file
/up-to-date/ {
s/youtube-dl is //
s/ (/|/
s/)//
}
# cleans up after an update
/Updated/d
s/Updating to version /Updated to|/
# cleans up Error messages
/ERROR/ {
s/ERROR: /ERROR|/
s/ the current version.//
s/ Please.*//
s/Aborting/Aborted/
}
