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

void cFD_SET(int sockfd, fd_set* set) {
	FD_SET(sockfd, set);
}

int cFD_ISSET(int sockfd, fd_set* set) {
	return FD_ISSET(sockfd, set);
}

void cFD_ZERO(fd_set* set) {
	FD_ZERO(set);
}

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

void cAtexit(void *func) {
	atexit(func);
}
