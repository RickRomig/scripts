# cleans up yt-dlp update log file
/up to date/ {
s/yt-dlp is //
s/ (/|/
s/stable@//
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
