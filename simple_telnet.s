	.file	"simple_telnet.c"
	.text
	.globl	negotiate
	.type	negotiate, @function
negotiate:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$72, %esp
	movl	12(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	-44(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$-3, %al
	jne	.L2
	movl	-44(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	cmpb	$31, %al
	jne	.L2
	movb	$-1, -31(%ebp)
	movb	$-5, -30(%ebp)
	movb	$31, -29(%ebp)
	movl	$0, 12(%esp)
	movl	$3, 8(%esp)
	leal	-31(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	send
	testl	%eax, %eax
	jns	.L3
	movl	$1, (%esp)
	call	exit
.L3:
	movb	$-1, -21(%ebp)
	movb	$-6, -20(%ebp)
	movb	$31, -19(%ebp)
	movb	$0, -18(%ebp)
	movb	$80, -17(%ebp)
	movb	$0, -16(%ebp)
	movb	$24, -15(%ebp)
	movb	$-1, -14(%ebp)
	movb	$-16, -13(%ebp)
	movl	$0, 12(%esp)
	movl	$9, 8(%esp)
	leal	-21(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	send
	testl	%eax, %eax
	jns	.L4
	movl	$1, (%esp)
	call	exit
.L4:
	nop
	jmp	.L1
.L2:
	movl	$0, -28(%ebp)
	jmp	.L6
.L9:
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$-3, %al
	jne	.L7
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movb	$-4, (%eax)
	jmp	.L8
.L7:
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$-5, %al
	jne	.L8
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movb	$-3, (%eax)
.L8:
	addl	$1, -28(%ebp)
.L6:
	movl	-28(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L9
	movl	16(%ebp), %eax
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	send
	testl	%eax, %eax
	jns	.L1
	movl	$1, (%esp)
	call	exit
.L1:
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L10
	call	__stack_chk_fail
.L10:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	negotiate, .-negotiate
	.local	tin
	.comm	tin,60,32
	.type	terminal_set, @function
terminal_set:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$tin, 4(%esp)
	movl	$0, (%esp)
	call	tcgetattr
	movl	tin, %eax
	movl	%eax, tlocal.3591
	movl	tin+4, %eax
	movl	%eax, tlocal.3591+4
	movl	tin+8, %eax
	movl	%eax, tlocal.3591+8
	movl	tin+12, %eax
	movl	%eax, tlocal.3591+12
	movl	tin+16, %eax
	movl	%eax, tlocal.3591+16
	movl	tin+20, %eax
	movl	%eax, tlocal.3591+20
	movl	tin+24, %eax
	movl	%eax, tlocal.3591+24
	movl	tin+28, %eax
	movl	%eax, tlocal.3591+28
	movl	tin+32, %eax
	movl	%eax, tlocal.3591+32
	movl	tin+36, %eax
	movl	%eax, tlocal.3591+36
	movl	tin+40, %eax
	movl	%eax, tlocal.3591+40
	movl	tin+44, %eax
	movl	%eax, tlocal.3591+44
	movl	tin+48, %eax
	movl	%eax, tlocal.3591+48
	movl	tin+52, %eax
	movl	%eax, tlocal.3591+52
	movl	tin+56, %eax
	movl	%eax, tlocal.3591+56
	movl	$tlocal.3591, (%esp)
	call	cfmakeraw
	movl	$tlocal.3591, 8(%esp)
	movl	$0, 4(%esp)
	movl	$0, (%esp)
	call	tcsetattr
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	terminal_set, .-terminal_set
	.type	terminal_reset, @function
terminal_reset:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$tin, 8(%esp)
	movl	$0, 4(%esp)
	movl	$0, (%esp)
	call	tcsetattr
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	terminal_reset, .-terminal_reset
	.section	.rodata
.LC0:
	.string	"Usage: %s address [port]\n"
	.align 4
.LC1:
	.string	"Could not create socket. Error"
.LC2:
	.string	"connect failed. Error"
.LC3:
	.string	"Connected...\n"
.LC4:
	.string	"select. Error"
	.align 4
.LC5:
	.string	"Connection closed by the remote end\n\r"
.LC6:
	.string	"%s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	andl	$-16, %esp
	subl	$240, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	12(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	%gs:20, %eax
	movl	%eax, 236(%esp)
	xorl	%eax, %eax
	cmpl	$1, 8(%ebp)
	jle	.L14
	cmpl	$3, 8(%ebp)
	jle	.L15
.L14:
	movl	28(%esp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	printf
	movl	$1, %eax
	jmp	.L34
.L15:
	movl	$23, 32(%esp)
	cmpl	$3, 8(%ebp)
	jne	.L17
	movl	28(%esp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, 32(%esp)
.L17:
	movl	$0, 8(%esp)
	movl	$1, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, 36(%esp)
	cmpl	$-1, 36(%esp)
	jne	.L18
	movl	$.LC1, (%esp)
	call	perror
	movl	$1, %eax
	jmp	.L34
.L18:
	movl	28(%esp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	inet_addr
	movl	%eax, 200(%esp)
	movw	$2, 196(%esp)
	movl	32(%esp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, 198(%esp)
	movl	$16, 8(%esp)
	leal	196(%esp), %eax
	movl	%eax, 4(%esp)
	movl	36(%esp), %eax
	movl	%eax, (%esp)
	call	connect
	testl	%eax, %eax
	jns	.L19
	movl	$.LC2, (%esp)
	call	perror
	movl	$1, %eax
	jmp	.L34
.L19:
	movl	$.LC3, (%esp)
	call	puts
	call	terminal_set
	movl	$terminal_reset, (%esp)
	call	atexit
	movl	$1, 60(%esp)
	movl	$0, 64(%esp)
.L33:
	movl	$0, %eax
	movl	$32, %ecx
	leal	68(%esp), %edx
	movl	%edx, %edi
#APP
# 154 "simple_telnet.c" 1
	cld; rep; stosl
# 0 "" 2
#NO_APP
	movl	%edi, %edx
	movl	%ecx, 40(%esp)
	movl	%edx, 44(%esp)
	cmpl	$0, 36(%esp)
	je	.L20
	movl	36(%esp), %eax
	leal	31(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$5, %eax
	movl	68(%esp,%eax,4), %ebx
	movl	36(%esp), %edx
	movl	%edx, %ecx
	sarl	$31, %ecx
	shrl	$27, %ecx
	addl	%ecx, %edx
	andl	$31, %edx
	subl	%ecx, %edx
	movl	$1, %esi
	movl	%edx, %ecx
	sall	%cl, %esi
	movl	%esi, %edx
	orl	%ebx, %edx
	movl	%edx, 68(%esp,%eax,4)
.L20:
	movl	68(%esp), %eax
	orl	$1, %eax
	movl	%eax, 68(%esp)
	movl	36(%esp), %eax
	leal	1(%eax), %edx
	leal	60(%esp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	68(%esp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	select
	movl	%eax, 48(%esp)
	cmpl	$0, 48(%esp)
	jns	.L21
	movl	$.LC4, (%esp)
	call	perror
	movl	$1, %eax
	jmp	.L34
.L21:
	cmpl	$0, 48(%esp)
	jne	.L23
	movl	$1, 60(%esp)
	movl	$0, 64(%esp)
	jmp	.L24
.L23:
	cmpl	$0, 36(%esp)
	je	.L25
	movl	36(%esp), %eax
	leal	31(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$5, %eax
	movl	68(%esp,%eax,4), %ebx
	movl	36(%esp), %eax
	cltd
	shrl	$27, %edx
	addl	%edx, %eax
	andl	$31, %eax
	subl	%edx, %eax
	movl	%eax, %ecx
	sarl	%cl, %ebx
	movl	%ebx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L25
	movl	$0, 12(%esp)
	movl	$1, 8(%esp)
	leal	215(%esp), %eax
	movl	%eax, 4(%esp)
	movl	36(%esp), %eax
	movl	%eax, (%esp)
	call	recv
	movl	%eax, 52(%esp)
	cmpl	$0, 52(%esp)
	jns	.L26
	movl	$1, %eax
	jmp	.L34
.L26:
	cmpl	$0, 52(%esp)
	jne	.L27
	movl	$.LC5, (%esp)
	call	printf
	movl	$0, %eax
	jmp	.L34
.L27:
	movzbl	215(%esp), %eax
	cmpb	$-1, %al
	jne	.L28
	movl	$0, 12(%esp)
	movl	$2, 8(%esp)
	leal	215(%esp), %eax
	addl	$1, %eax
	movl	%eax, 4(%esp)
	movl	36(%esp), %eax
	movl	%eax, (%esp)
	call	recv
	movl	%eax, 56(%esp)
	cmpl	$0, 56(%esp)
	jns	.L29
	movl	$1, %eax
	jmp	.L34
.L29:
	cmpl	$0, 56(%esp)
	jne	.L30
	movl	$.LC5, (%esp)
	call	printf
	movl	$0, %eax
	jmp	.L34
.L30:
	movl	$3, 8(%esp)
	leal	215(%esp), %eax
	movl	%eax, 4(%esp)
	movl	36(%esp), %eax
	movl	%eax, (%esp)
	call	negotiate
	jmp	.L24
.L28:
	movl	$1, 56(%esp)
	leal	215(%esp), %edx
	movl	56(%esp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
	leal	215(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC6, (%esp)
	call	printf
	movl	$0, (%esp)
	call	fflush
	jmp	.L24
.L25:
	movl	68(%esp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L24
	movl	stdin, %eax
	movl	%eax, (%esp)
	call	_IO_getc
	movb	%al, 215(%esp)
	movl	$0, 12(%esp)
	movl	$1, 8(%esp)
	leal	215(%esp), %eax
	movl	%eax, 4(%esp)
	movl	36(%esp), %eax
	movl	%eax, (%esp)
	call	send
	testl	%eax, %eax
	jns	.L32
	movl	$1, %eax
	jmp	.L34
.L32:
	movzbl	215(%esp), %eax
	cmpb	$10, %al
	jne	.L24
	movl	$13, (%esp)
	call	putchar
	jmp	.L33
.L24:
	jmp	.L33
.L34:
	movl	236(%esp), %edi
	xorl	%gs:20, %edi
	je	.L35
	call	__stack_chk_fail
.L35:
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.local	tlocal.3591
	.comm	tlocal.3591,60,32
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
