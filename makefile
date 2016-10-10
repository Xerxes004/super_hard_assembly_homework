all: telnet_client

telnet_client: telnet_client_handout.s funcs.c
#	gcc -nostartfiles -m32 -nostdlib -gstabs -o telnet_client telnet_client_handout.s term.s
	gcc -m32 -nostartfiles -lc -c funcs.c
	gcc -nostartfiles -m32 -gstabs -o telnet_client telnet_client_handout.s term.s funcs.o -lc

run: all
	./telnet_client 23.253.235.38 1701

clean:
	rm -f telnet_client

backup:
	mkdir -vp backups/
	zip backups/backup-$(shell date +%H:%M:%S).zip *
