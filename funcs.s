	.file	"funcs.c"
	.text
	.globl	cFD_SET
	.type	cFD_SET, @function
cFD_SET:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	8(%ebp), %eax
	leal	31(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$5, %eax
	movl	12(%ebp), %edx
	movl	(%edx,%eax,4), %ebx
	movl	8(%ebp), %edx
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
	orl	%edx, %ebx
	movl	%ebx, %ecx
	movl	12(%ebp), %edx
	movl	%ecx, (%edx,%eax,4)
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	cFD_SET, .-cFD_SET
	.globl	cFD_ISSET
	.type	cFD_ISSET, @function
cFD_ISSET:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	leal	31(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$5, %eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	movl	(%eax,%edx,4), %ebx
	movl	8(%ebp), %eax
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
	setne	%al
	movzbl	%al, %eax
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	cFD_ISSET, .-cFD_ISSET
	.globl	cFD_ZERO
	.type	cFD_ZERO, @function
cFD_ZERO:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	subl	$16, %esp
	.cfi_offset 7, -12
	movl	8(%ebp), %edx
	movl	$0, %eax
	movl	$32, %ecx
	movl	%edx, %edi
#APP
# 51 "funcs.c" 1
	cld; rep; stosl
# 0 "" 2
#NO_APP
	movl	%edi, %edx
	movl	%ecx, -12(%ebp)
	movl	%edx, -8(%ebp)
	addl	$16, %esp
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	cFD_ZERO, .-cFD_ZERO
	.globl	negotiate
	.type	negotiate, @function
negotiate:
.LFB5:
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
	jne	.L6
	movl	-44(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	cmpb	$31, %al
	jne	.L6
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
	jns	.L7
	movl	$1, (%esp)
	call	exit
.L7:
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
	jns	.L8
	movl	$1, (%esp)
	call	exit
.L8:
	nop
	jmp	.L5
.L6:
	movl	$0, -28(%ebp)
	jmp	.L10
.L13:
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$-3, %al
	jne	.L11
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movb	$-4, (%eax)
	jmp	.L12
.L11:
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$-5, %al
	jne	.L12
	movl	-28(%ebp), %edx
	movl	-44(%ebp), %eax
	addl	%edx, %eax
	movb	$-3, (%eax)
.L12:
	addl	$1, -28(%ebp)
.L10:
	movl	-28(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L13
	movl	16(%ebp), %eax
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	send
	testl	%eax, %eax
	jns	.L5
	movl	$1, (%esp)
	call	exit
.L5:
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L14
	call	__stack_chk_fail
.L14:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	negotiate, .-negotiate
	.local	tin
	.comm	tin,60,32
	.type	terminal_set, @function
terminal_set:
.LFB6:
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
	movl	%eax, tlocal.3604
	movl	tin+4, %eax
	movl	%eax, tlocal.3604+4
	movl	tin+8, %eax
	movl	%eax, tlocal.3604+8
	movl	tin+12, %eax
	movl	%eax, tlocal.3604+12
	movl	tin+16, %eax
	movl	%eax, tlocal.3604+16
	movl	tin+20, %eax
	movl	%eax, tlocal.3604+20
	movl	tin+24, %eax
	movl	%eax, tlocal.3604+24
	movl	tin+28, %eax
	movl	%eax, tlocal.3604+28
	movl	tin+32, %eax
	movl	%eax, tlocal.3604+32
	movl	tin+36, %eax
	movl	%eax, tlocal.3604+36
	movl	tin+40, %eax
	movl	%eax, tlocal.3604+40
	movl	tin+44, %eax
	movl	%eax, tlocal.3604+44
	movl	tin+48, %eax
	movl	%eax, tlocal.3604+48
	movl	tin+52, %eax
	movl	%eax, tlocal.3604+52
	movl	tin+56, %eax
	movl	%eax, tlocal.3604+56
	movl	$tlocal.3604, (%esp)
	call	cfmakeraw
	movl	$tlocal.3604, 8(%esp)
	movl	$0, 4(%esp)
	movl	$0, (%esp)
	call	tcsetattr
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	terminal_set, .-terminal_set
	.type	terminal_reset, @function
terminal_reset:
.LFB7:
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
.LFE7:
	.size	terminal_reset, .-terminal_reset
	.globl	cAtexit
	.type	cAtexit, @function
cAtexit:
.LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	atexit
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	cAtexit, .-cAtexit
	.local	tlocal.3604
	.comm	tlocal.3604,60,32
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
