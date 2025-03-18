all:

cp:
	@rm duckpond.tar
	@zstd -d duckpond.tar.zst
	sudo docker load -i ./duckpond.tar
