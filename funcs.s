	.file	"funcs.c"
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
	.local	tlocal.3591
	.comm	tlocal.3591,60,32
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
