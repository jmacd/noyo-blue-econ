all:

cp:
	zstd -d duckpond.tar.zst
	sudo docker load -i ./duckpond.tar
