	.file	"dotprod2.c"
	.text
	.p2align 4
	.globl	dotprod_unroll2
	.type	dotprod_unroll2, @function
dotprod_unroll2:
.LFB0:
	.cfi_startproc
	endbr64
	testq	%rdx, %rdx
	je	.L4
	subq	$1, %rdx
	xorl	%eax, %eax
	pxor	%xmm1, %xmm1
	shrq	%rdx
	leaq	1(%rdx), %rcx
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L3:
	movupd	(%rsi,%rax), %xmm0
	movupd	(%rdi,%rax), %xmm3
	addq	$1, %rdx
	addq	$16, %rax
	mulpd	%xmm3, %xmm0
	addpd	%xmm0, %xmm1
	cmpq	%rcx, %rdx
	jb	.L3
	movapd	%xmm1, %xmm4
	movapd	%xmm1, %xmm0
	unpckhpd	%xmm4, %xmm4
	addsd	%xmm4, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	pxor	%xmm0, %xmm0
	ret
	.cfi_endproc
.LFE0:
	.size	dotprod_unroll2, .-dotprod_unroll2
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4: