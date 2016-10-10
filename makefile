all: telnet_client

telnet_client: telnet_client_handout.s 
#	gcc -nostartfiles -m32 -nostdlib -gstabs -o telnet_client telnet_client_handout.s term.s
	gcc -m32 -nostartfiles -lc -c funcs.c
	gcc -nostartfiles -m32 -gstabs -o telnet_client telnet_client_handout.s term.s funcs.o -lc


clean:
	rm -f telnet_client

backup:
	mkdir -vp backups/
	zip backups/backup-$(shell date +%H:%M:%S).zip *
