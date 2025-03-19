all:

cp:
	@rm /home/jmacd/duckpond.tar
	@zstd -d /home/jmacd/duckpond.tar.zst
	sudo docker load -i /home/jmacd/duckpond.tar
