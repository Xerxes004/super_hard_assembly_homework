/*
    SimpleTelnet: a simple telnet client suitable for embedded systems
    Copyright (C) 2013  netblue30@yahoo.com

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <termios.h>
#include <fcntl.h>
 
#define ESBN 0xf0
#define SUBN 0xfa
#define WILL 0xfb
#define WONT 0xfc
#define DO   0xfd
#define DONT 0xfe
#define CMD  0xff

#define TRMW   80
#define TRMH   24

#define CMD_ECHO 1
#define CMD_WINDOW_SIZE 31
 
void negotiate(int sock, unsigned char *buf, int len) {
     
	 /* communicate to the remote application the local terminal's window size */
    if (buf[1] == DO && buf[2] == CMD_WINDOW_SIZE) {
        unsigned char tmp1[] = {CMD, WILL, CMD_WINDOW_SIZE};
        if (send(sock, tmp1, 3 , 0) < 0)
            exit(1);
         
        unsigned char tmp2[] = {CMD, SUBN, CMD_WINDOW_SIZE, 0, TRMW, 
										 0, TRMH, CMD, ESBN};
        if (send(sock, tmp2, 9, 0) < 0)
            exit(1);
        return;
    }
     
	 /* appears to be replying to the remote app, that this app WONT
       accept commands, but WILL respond to requests.               */
    int i;
    for (i = 0; i < len; i++) {
        if (buf[i] == DO)
            buf[i] = WONT;
        else if (buf[i] == WILL)
            buf[i] = DO;
    }
 
	 /* send that feedback */
    if (send(sock, buf, len , 0) < 0)
        exit(1);
}
 
// stores the original terminal configuration
static struct termios tin;
 
// set the local terminal configuration to allow "raw" I/O
static void terminal_set(void) {
    // save terminal configuration
    tcgetattr(STDIN_FILENO, &tin);
     
	 // make a copy of the present configuration
    static struct termios tlocal;
    memcpy(&tlocal, &tin, sizeof(tin));

	 // turn on "raw" I/O
    cfmakeraw(&tlocal);

	 // make its effect immediate
    tcsetattr(STDIN_FILENO,TCSANOW,&tlocal);
}
 
// restore original terminal configuration upon exit
static void terminal_reset(void) {
    tcsetattr(STDIN_FILENO,TCSANOW,&tin);
}
 
// size of communication buffer between local and remote
#define BUFLEN 20

// simple telnet client:  takes the ip address of a telnet sever and optionally
// a port number (default 23)
int main(int argc , char *argv[]) {

    int sock;                          // file descriptor for the connection
    struct sockaddr_in server;         // information for connecting to remote
    unsigned char buf[BUFLEN + 1];     // communication buffer
    int len;                           // bytes in buffer
 
	 // check usage
    if (argc < 2 || argc > 3) {
        printf("Usage: %s address [port]\n", argv[0]);
        return 1;
    }

	 // assign port
    int port = 23;
    if (argc == 3)
        port = atoi(argv[2]);
 
    // create socket
    sock = socket(AF_INET , SOCK_STREAM , 0);
    if (sock == -1) {
        perror("Could not create socket. Error");
        return 1;
    }
 
	 // set the connection attributes
    server.sin_addr.s_addr = inet_addr(argv[1]);
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
 
    // connect to remote server
    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0) {
        perror("connect failed. Error");
        return 1;
    }
    puts("Connected...\n");
 
    // set local terminal configuration
    terminal_set();

	 // restore original configuration on exit from application
    atexit(terminal_reset);
     
	 // wait one second between polls for data
    struct timeval ts;
    ts.tv_sec = 1; // 1 second
    ts.tv_usec = 0;
 
    // loop infinitely -- program will terminate when connection is terminated
    while (1) {

        // select setup
        fd_set fds;
        FD_ZERO(&fds);
        if (sock != 0)
            FD_SET(sock, &fds);
        FD_SET(0, &fds);
 
        // wait for data
        int nready = select(sock + 1, &fds, (fd_set *) 0, (fd_set *) 0, &ts);
        if (nready < 0) {
            perror("select. Error");
            return 1;
        }

		  // no data, then reset wait time
        else if (nready == 0) {
            ts.tv_sec = 1; 
            ts.tv_usec = 0;
        }

		  // there is data to receive on the socket
        else if (sock != 0 && FD_ISSET(sock, &fds)) {

            // start by reading a single byte
            int rv;
            if ((rv = recv(sock , buf , 1 , 0)) < 0)
                return 1;
            else if (rv == 0) {
                printf("Connection closed by the remote end\n\r");
                return 0;
            }
 
			   // handle command messaages separate from "ordinary" data
            if (buf[0] == CMD) {
                // read 2 more bytes
                len = recv(sock , buf + 1 , 2 , 0);
                if (len  < 0)
                    return 1;
                else if (len == 0) {
                    printf("Connection closed by the remote end\n\r");
                    return 0;
                }
                negotiate(sock, buf, 3);
            }

				// print received data to stdout
            else {
                len = 1;
                buf[len] = '\0';
                printf("%s", buf);
                fflush(0);
            }
        }
         
		  // there is data on stdin to send out to the socket
        else if (FD_ISSET(0, &fds)) {

				// read a single char into buf
            buf[0] = getc(stdin);

				// send the char over the socket to remote
            if (send(sock, buf, 1, 0) < 0)
                return 1;

 				// with the terminal in raw mode we need to force a LF
            if (buf[0] == '\n')
                putchar('\r');
        }
    }

    close(sock);

    return 0;
}
