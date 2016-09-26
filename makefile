all: telnet_client

telnet_client: telnet_client.s
	gcc -m32 -nostdlib -gstabs -o telnet_client telnet_client.s

clean:
	rm -f telnet_client

backup:
	mkdir -vp backups/
	zip backups/backup-$(shell date +%H:%M:%S).zip *
