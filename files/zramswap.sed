/ALGO/ {
	s/^#//
	s/lz4$/zstd
}
/PERCENT/ {
	s/^#//
	s/50$/25/
}
/SIZE/ {
	s/^SIZE/#SIZE/
}
/PRIORITY/ {
	s/^#//
}
