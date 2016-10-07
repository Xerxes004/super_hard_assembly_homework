#include <stdlib.h>
#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <fcntl.h>

int main() {
  struct fd_set fs;
  FD_ISSET(1, &fs);
  return 0;

}
