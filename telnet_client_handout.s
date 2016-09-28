# Telnet written in 32-bit x86 assembly, using Linux system calls only
# Vanya A. Sergeev - vsergeev at gmail - 01/12/2009
# The original NASM code is online at http://theanine.io/projects/telnet_asm
#
# Orginally written in NASM assembly and assembled and linked with
#  nasm -f elf telnet_client.asm -o telnet_client.o
#  ld -s telnet_client.o -o telnet_client
#
#  and tested on i686 Linux, kernel version 2.6.27
#
# Translated by Keith Shomper to GAS assembly using intel2gas, a utility 
# located at freecode.com/projects/intel2gas.
#
# Now assembled and linked with
#  as --32 telnet_client.s -o telnet_client.o
#  ld telnet_client.o -o telnet_client
#
#  or gcc -m32 -nostdlib -gstabs -o telnet_client telnet_client.s
#
#  and tested on i686 Linux, kernel version 4.4.28, using kdbg
#
# TODO:  Using the provided C-language implementation for a simple telnet client 
#        complete the application by:
#        1. Completing the negotiate() function
#        2. Completing the terminal_set() and terminal_reset() functions
#        3. Declaring and storing values to a timeval structure, as appropriate
#        4. Handling socket input: (read socket/write stdout)
#        5. Handling socket output: (read stdin/write socket)
#          
# Usage: ./telnet_client <IP address> <port>
# Note: host name resolution is not implemented. This version only takes IP
# addresses.
#
# You can see what is supposed to happen by running a real telnet client, e.g.,
# telnet 69.16.139.230 23
# 
# Entering the above command gives you a connection to the telehack.com where
# you can interact via sending commands and receiving data.  To terminate the
# connection, type "quit"
# 
# To Run:
# $ ./telnet_client 69.16.139.230 23
#
#####################################################################

.data
    msgInvalidArguments:
	.asciz "Invalid IP address or port supplied.\n"
    msgIAEnd:
      .equ msgInvalidArgumentsLen, msgIAEnd - msgInvalidArguments

    msgErrorSocket:
	.asciz "Error creating socket.\n"
    msgESocEnd:
    	.equ msgErrorSocketLen, msgESocEnd - msgErrorSocket

    msgErrorConnect:
	.asciz "Error connecting to server.\n"
    msgECEnd:
    	.equ msgErrorConnectLen, msgECEnd - msgErrorConnect

    msgTryingConnect:
	.asciz "Trying to connect to server.\n"
    msgTCEnd:
    	.equ msgTryingConnectLen, msgTCEnd - msgTryingConnect

    msgConnected:
	.asciz "Connected to server.\n"
    msgCEnd:
    	.equ msgConnectedLen, msgCEnd - msgConnected

    msgErrorSelect:
	.asciz "Error with select().\n"
    msgESelEnd:
    	.equ msgErrorSelectLen, msgESelEnd - msgErrorSelect

    msgUsage:
	.asciz "Usage: ./telnet <IP address> <port>\n"
    msgUEnd:
	.equ msgUsageLen, msgUEnd - msgUsage

    # Arguments for socket(): socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    socketArgs:
      .long 2,1,6

#####################################################################

.bss
    # Socket file descriptor returned by socket()
    .lcomm sockfd,   4

    # Storage for the 4 IP octets 
    .lcomm ipOctets, 4

    # Storage for the connection port represented in one 16-bit word
    .lcomm ipPort,   2

    # Arguments for connect(): 
    #   connect(sockfd, serverSockaddr, serversockaddrLen);
    .lcomm connectArgs,        24

    # The read file descriptor struct for select()
    .lcomm fdSetValues,       128
    .equ   fdSetValuesLen,    128

    # sockaddr_in structure that needs to be filled in for the
    # connect() system call.
    #   struct in_addr {
    #       unsigned long s_addr;
    #   };
    #   struct sockaddr_in {
    #       short            sin_family;
    #       unsigned short   sin_port;
    #       struct in_addr   sin_addr;
    #       char             sin_zero[8];
    #   };
    .lcomm serverSockaddr,     16         # i.e., 2+2+4+8  -- see above structs
    .equ   serverSockaddrLen,  16

    # TODO:
    # termios structure that needs to be filled in for the terminal_*
    # functions.
    # 
    # Read buffer for reading from stdin and the socket
    .lcomm readBuffer,       1024
    .lcomm readBufferLen,       4
    .equ   readBufferMaxLen, 1024

    # Arguments for negotiate():
    #   negotiate(int sock, unsigned char* buf, int len);
    .lcomm negotiateArgs,      24

#####################################################################

.text
    .global _start

  _start: 
    # Pop argc, storing the value into %eax
    popl  %eax

    # Check if we have the correct number of arguments (3), for the 
    # program name, IP address, and port number.
    cmpl  $3, %eax
    je    parse_program_arguments

    # Otherwise, print the usage and quit.
    pushl $msgUsage
    pushl $msgUsageLen
    call  cWriteString
    addl  $8, %esp
    call  cExit

  parse_program_arguments: 
    # Set the direction flag to increment, so edi/esi are INCREMENTED
    # with their respective load/store instructions.
    cld

    # Pop the program name string
    popl  %eax

    # Convert the port and IP address strings to numbers
    # Next on the stack is the IP address
    # Convert the IP address string to four byte sized octets.
    call  cStrIP_to_Octets
    addl  $4, %esp

    # Check for errors. If %eax had a 0, then cStrIP_to_Octets had an error
    cmpl  $0, %eax
    # jl is "jump to label"
    jl    invalid_program_arguments

    # Next on the stack is the port
    # Convert the port string to a 16-bit word.
    call  cStrtoul
    addl  $4, %esp
    movl  %eax, ipPort

    # Check for errors
    cmpl  $0, %eax
    jge network_open_socket

    # Otherwise, print error for invalid arguments and quit.
  invalid_program_arguments: 
    pushl $msgInvalidArguments
    pushl $msgInvalidArgumentsLen
    call  cWriteString
    addl  $8, %esp
    call  cExit

  network_open_socket: 
    # Open a socket and store it in sockfd
    # Syscall socketcall(1, ...); for socket();
    movl  $102, %eax
    movl  $1, %ebx
    movl  $socketArgs, %ecx
    int   $0x80

    # Copy our socket file descriptor to our variable sockfd
    movl  %eax, sockfd

    # Check if socket() returned a valid socket file descriptor
    cmpl  $0, %eax
    jge   network_connect

    # Otherwise, print error creating socket and quit.
    pushl $msgErrorSocket
    pushl $msgErrorSocketLen
    call  cWriteString
    addl  $8, %esp
    call  cExit

  network_connect: 
    # Print trying to connect message
    pushl $msgTryingConnect
    pushl $msgTryingConnectLen
    call  cWriteString
    addl  $8, %esp

    # Setup the argument to connect() and call connect()
    # Fill in the sockaddr_in structure with the
    # network family, port, and IP address information,
    # along with the zeros in the zero field.
    movl $serverSockaddr, %edi

    # Store the network family, AF_INET = 2
    movb  $2, %al
    stosb
    movb  $0, %al
    stosb

    ### Store the port, in network byte order (big endian).
    # High byte first
    movw  ipPort, %ax

    # Truncate the lower byte
    shrw  $8, %ax
    stosb

    # Low byte second
    movw  ipPort, %ax
    stosb

    # Store the 4 octets (bytes) of the IP address, reading from the
    # ipOctets 4-byte array and copying to the respective
    # locations in the serverSockaddr structure.
    movl  $ipOctets, %esi
    movsl

    # Zero out the remaining 8 bytes of the structure
    movb  $0, %al
    movl  $8, %ecx
    rep
    stosb

    # Setup the array that will hold the arguments for connect 
    # we are passing through the socketcall() system call.
    movl  $connectArgs, %edi

    # sockfd
    movl  sockfd, %eax
    stosl

    # Pointer to serverSockaddr structure
    movl  $serverSockaddr, %eax
    stosl

    # serverSockaddrlen
    movl  $serverSockaddrLen, %eax
    stosl

    # Syscall socketcall(sockfd, ...); for connect();
    movl  $102, %eax
    movl  sockfd, %ebx
    movl  $connectArgs, %ecx
    int   $0x80

    # Check if connect() returned a success
    cmpl  $0, %eax
    jge   network_setup_file_descriptors

    # Otherwise, print error creating socket and quit.
    pushl $msgErrorConnect
    pushl $msgErrorConnectLen
    call  cWriteString
    addl  $8, %esp
    jmp   network_premature_exit

  network_setup_file_descriptors: 
    # Print connect message
    pushl $msgConnected
    pushl $msgConnectedLen
    call  cWriteString
    addl  $8, %esp

    # TODO:  set up terminal for raw I/O
    
    
    # WK: call tcgetattr(STDIN_FILENO, &tin);
    
    
  network_read_write_loop:
    # Head of infinite loop to read and write the socket 
    # while (1) {

    # Syscall select(sock + 1, &fds, (fd_set *) 0, (fd_set *) 0, &ts);
    movl  $142, %eax
    movl  sockfd, %ebx
    incl  %ebx
    movl  $fdSetValues, %ecx
    movl  $0, %edx
    movl  $0, %esi
    movl  $0, %edi
    int   $0x80

    # Check the return value of select for errors
    cmpl  $0,%eax
    jg    check_read_file_descriptors

    # Otherwise, print error calling select and quit
    pushl $msgErrorSelect
    pushl $msgErrorSelectLen
    call  cWriteString
    addl  $8, %esp
    jmp   network_premature_exit

  check_read_file_descriptors:
    # if (nready == 0) {
    # TODO: set time structure

    check_socket_file_descriptor: 
    # if (sock !=0 && FD_ISSET ...)) {
    # TODO: handle socket communication
    # - if error
    # - if disconnect
    # - if command string
    # - if ordinary data

  check_stdin_file_descriptor: 
    # if (FD_ISSET (0, ...)) {
    # TODO: read commands from stdin and write to socket

  check_socket_file_descriptor_done: 
    # Loop back to the select() system call to check for more data
    jmp   network_read_write_loop

  network_premature_exit: 
  network_close_socket: 
    # Syscall close(sockfd);
    movl  $6, %eax
    movl  sockfd, %ebx
    int   $0x80

    call cExit

#####################################################################

#
# cExit
#   Exits program with the exit() syscall.
#       arguments: none
#       returns: nothing
#
  cExit: 
    # Syscall exit(0);
    movl  $1, %eax
    movl  $0, %ebx
    int   $0x80
    ret

#
# cReadStdin
#   Reads from stdin into readBuffer.
#   Sets readBuffLen with number of bytes read.
#       arguments: none
#       returns: number of bytes read on success, -1 on error, in eax
#
  cReadStdin: 
    # Syscall read(0, readBuffer, readBufferMaxLen);
    movl  $3, %eax
    movl  $0, %ebx
    movl  $readBuffer, %ecx
    movl  $readBufferMaxLen, %edx
    int   $0x80

    movl  %eax, readBufferLen
    ret

#
# cReadSocket
#   Reads from the socket sockfd into readBuffer.
#   Sets readBuffLen with number of bytes read.
#       arguments: none
#       returns: number of bytes read on success, -1 on error, in eax
#
  cReadSocket: 
    # Syscall read(sockfd, readBuffer, readBufferMaxLen);
    movl  $3, %eax
    movl  sockfd, %ebx
    movl  $readBuffer, %ecx
    movl  $readBufferMaxLen, %edx
    int   $0x80

    movl  %eax, readBufferLen
    ret

#
# cWriteStdout:
#   Writes readBufferLen bytes of readBuff to stdout.
#       arguments: none
#       returns: number of bytes written on success, -1 on error, in eax
#
  cWriteStdout: 
    # Syscall write(1, readBuffer, readBufferLen);
    movl  $4, %eax
    movl  $1, %ebx
    movl  $readBuffer, %ecx
    movl  readBufferLen, %edx
    int   $0x80
    ret

#
# cWriteSocket
#   Writes readBufferLen bytes of readBuff to the socket sockfd.
#       arguments: none
#       returns: number of bytes written on success, -1 on error, in eax
#
  cWriteSocket: 
    # Syscall write(sockfd, readBuff, readBuffLen);
    movl  $4, %eax
    movl  sockfd, %ebx
    movl  $readBuffer, %ecx
    movl  readBufferLen, %edx
    int   $0x80
    ret

#
# cWriteString
#   Prints message loaded on stack to stdout.
#       arguments: message to write, message length
#       returns: nothing
#
  cWriteString: 
    pushl %ebp
    movl  %esp,%ebp

    # Syscall write(stdout, message, message length);
    movl  $4, %eax
    movl  $1, %ebx

    # Message poitner
    movl  12(%ebp), %ecx

    # Message length
    movl   8(%ebp), %edx
    int   $0x80

    movl  %ebp,%esp
    popl  %ebp
    ret

#
# cStrIP_to_Octets
#   Parses an ASCII IP address string, e.g. "127.0.0.1", and stores the
#   numerical representation of the 4 octets in the ipOctets variable.
#       arguments: pointer to the IP address string
#       returns: 0 on success, -1 on failure
#
  cStrIP_to_Octets: 
    pushl %ebp
    movl  %esp, %ebp

    # Allocate space for a temporary 3 digit substring variable of the IP
    # address, used to parse the IP address.
    subl  $4, %esp

    # Point esi to the beginning of the string
    movl   8(%ebp), %esi

    # Reset our counter, we'll use this to iterate through the
    # 3 digits of each octet.
    movl  $0, %ecx

    # Reset our octet counter, this is to keep track of the 4
    # octets we need to fill.
    movl  $0, %edx

    # Point edi to the beginning of the temporary
    # IP octet substring
    movl  %ebp, %edi
    subl  $4, %edi

    string_ip_parse_loop: 
        # Read the next character from the IP string
        lodsb

        # Increment our counter
        incl  %ecx

        # If we encounter a dot, process this octet
        cmpb  $'.', %al
        je    octet_complete

        # If we encounter a null character, process this
        # octet.
        cmpb  $0, %al
        je    null_byte_encountered

        # If we're already on our third digit,
        # process this octet.
        cmpl  $4, %ecx
        jge   octet_complete

        # Otherwise, copy the character to our
        # temporary octet string.
        stosb

        jmp   string_ip_parse_loop

      null_byte_encountered: 
        # Check to see if we are on the last octet yet
        # (current octet would be equal to 3)
        cmpl  $3, %edx

        # If so, everything is working normally
        je    octet_complete

        # Otherwise, this is a malformed IP address,
        # and we will return -1 for failure
        movl  $-1, %eax
        jmp   malformed_ip_address_exit

      octet_complete: 
        # Null terminate our temporary octet variable.
        movb  $0, %al
        stosb

        # Save our position in the IP address string
        pushl %esi

        # Save our octet counter
        pushl %edx

        # Send off our temporary octet string to our cStrtoul
        # function to turn it into a number.
        movl  %ebp, %eax
        subl  $4, %eax
        pushl %eax
        call  cStrtoul
        addl  $4, %esp

        # Check if we had any errors converting the string,
        # if so, go straight to exit (eax will hold error through)
        cmpl  $0, %eax
        jl    malformed_ip_address_exit

        # Restore our octet counter
        popl  %edx

        # Copy the octet data to the current IP octet
        # in our IP octet array.    
        movl  $ipOctets, %edi
        addl  %edx, %edi

        # cStrtoul saved the number in eax, so we should
        # be fine writing al to [edi].
        stosb

        # Increment our octet counter.
        incl  %edx

        # Restore our position in the IP address string
        popl  %esi
        # Reset the position on the temporary octet string
        movl  %ebp, %edi
        subl  $4, %edi

        # Continue to processing the next octet
        movl  $0, %ecx

        cmpl  $4, %edx
        jl    string_ip_parse_loop

    # Return 0 for success
    movl  $0, %eax

  malformed_ip_address_exit: 
    movl  %ebp, %esp
    popl  %ebp
    ret

#
# cStrtoul
#   Converts a number represented in an ASCII string to an unsigned 32-bit
#   integer.
#       arguments: pointer to the string
#       returns: 32-bit integer stored in eax
#
  cStrtoul: 
    pushl %ebp
    movl  %esp, %ebp

    # Allocate space for the multiply operand
    subl  $4, %esp

    # Point esi to the beginning of the string
    movl   8(%ebp), %esi

    # Make a copy of the string address in edi
    movl  %esi, %edi

    string_length_loop: 
        # Load the next byte from the string.
        # lodsb reads the byte pointed to by esi into %ala,
        # then INCREMENTS the %esi register
        lodsb

        # Compare the byte to the null byte
        cmpb  $0, %al

        # Continue to loop until the null byte is reached
        jne   string_length_loop

    # Copy the address of the null byte + 1 and subtract the
    # address of the string to have the string length in ebx 
    movl  %esi, %ebx
    subl  %edi, %ebx

    # Decrement by one to account for the null byte
    decl  %ebx

    # Ensure that the string length > 0
    cmpl  $0, %ebx
    jle   premature_exit

    # Use eax to hold the current character
    movl  $0, %eax

    # Use ecx to hold the digit position in terms of powers of ten
    movl  $0, %ecx

    # Use edx to hold the final result
    movl  $0, %edx

    # Set esi back to the beginning of the string so we can traverse it
    movl  %edi, %esi

    digits_count_loop: 
        # Read the next digit into al
        lodsb

        # Decrement our string length counter
        decl  %ebx

        # Start out at 10^0 = 1
        movl  $1, %ecx
        movl  $0, %edi

        # Check if we need to multiply by any more powers of 10 
        cmpl  %edi, %ebx

        # If not, then ecx = 10^0 = 1, so we can skip the exponent
        # multiplication loop.
        je    exponent_loop_skip

        # Otherwise, multiply ecx by 10 for however many powers
        # the current digit requires
        exponent_loop: 
            imull $10, %ecx
            incl  %edi
            cmpl  %edi, %ebx
            jg    exponent_loop

        exponent_loop_skip: 
            # Check if the character is 0 or greater
            cmpb  $48, %al
            jge   lower_bound_met

            # Otherwise, set the result to 0 and exit
            movl  $-1, %eax
            jmp   premature_exit

        lower_bound_met: 
            # Check if the character is 9 or less
            cmpb  $57, %al
            jle   upper_bound_met

            # Otherwise, set the result to 0 and exit
            movl  $-1, %eax
            jmp   premature_exit

        upper_bound_met:    

        # Subtract 48, the ASCII code for '0', from the character,
        # leaving just the digit in al
        subb  $48, %al

        # Multiply the powers of ten with the digit
        movl  %eax, -4(%ebp)
        imull -4(%ebp), %ecx

        # Add this digit value to the final result
        addl  %ecx, %edx

        # Continue looping until we have gone through all the digits
        cmpl  $0, %ebx
        jne   digits_count_loop

    # Move the result to eax
    movl  %edx, %eax

  premature_exit: 
    movl  %ebp, %esp
    popl  %ebp
    ret
