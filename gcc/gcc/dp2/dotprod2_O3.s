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
	je	.L6
	subq	$1, %rdx
	movq	%rdx, %rcx
	shrq	%rcx
	addq	$1, %rcx
	cmpq	$1, %rdx
	jbe	.L7
	movq	%rcx, %rdx
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	shrq	%rdx
	movapd	%xmm0, %xmm4
	salq	$5, %rdx
	.p2align 4,,10
	.p2align 3
.L4:
	movupd	(%rdi,%rax), %xmm3
	movupd	(%rsi,%rax), %xmm2
	movupd	16(%rdi,%rax), %xmm1
	movlpd	8(%rdi,%rax), %xmm1
	movhpd	16(%rdi,%rax), %xmm3
	movhpd	16(%rsi,%rax), %xmm2
	mulpd	%xmm3, %xmm2
	addsd	%xmm2, %xmm4
	unpckhpd	%xmm2, %xmm2
	addsd	%xmm2, %xmm4
	movupd	16(%rsi,%rax), %xmm2
	movlpd	8(%rsi,%rax), %xmm2
	addq	$32, %rax
	mulpd	%xmm2, %xmm1
	movapd	%xmm1, %xmm2
	unpckhpd	%xmm1, %xmm1
	addsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	addsd	%xmm2, %xmm0
	cmpq	%rdx, %rax
	jne	.L4
	movq	%rcx, %rdx
	andq	$-2, %rdx
	leaq	(%rdx,%rdx), %rax
	cmpq	%rcx, %rdx
	je	.L5
.L3:
	movsd	(%rsi,%rax,8), %xmm1
	mulsd	(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm4
	movsd	8(%rsi,%rax,8), %xmm1
	mulsd	8(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
.L5:
	addsd	%xmm4, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	pxor	%xmm0, %xmm0
	ret
.L7:
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	movapd	%xmm0, %xmm4
	jmp	.L3
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
