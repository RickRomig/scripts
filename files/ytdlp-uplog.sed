# cleans up yt-dlp update log file
/up to date/ {
s/yt-dlp is //
s/ (stable@/|/
s/)//
}
/Updated/ {
s/Updated yt-dlp to /updated to/
s/stable@/|/
}