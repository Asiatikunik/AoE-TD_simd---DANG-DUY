	.file	"dotprod1.c"
	.text
	.p2align 4
	.globl	dotprod
	.type	dotprod, @function
dotprod:
.LFB0:
	.cfi_startproc
	endbr64
	testq	%rdx, %rdx
	je	.L4
	xorl	%eax, %eax
	pxor	%xmm1, %xmm1
	.p2align 4,,10
	.p2align 3
.L3:
	movsd	(%rdi,%rax,8), %xmm0
	mulsd	(%rsi,%rax,8), %xmm0
	addq	$1, %rax
	addsd	%xmm0, %xmm1
	cmpq	%rax, %rdx
	jne	.L3
	movapd	%xmm1, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	pxor	%xmm1, %xmm1
	movapd	%xmm1, %xmm0
	ret
	.cfi_endproc
.LFE0:
	.size	dotprod, .-dotprod
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
