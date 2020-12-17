	.file	"dotprod2.c"
	.text
	.globl	dotprod_unroll2
	.type	dotprod_unroll2, @function
dotprod_unroll2:
.LFB0:
	.cfi_startproc
	endbr64
	testq	%rdx, %rdx
	je	.L4
	movl	$0, %eax
	pxor	%xmm2, %xmm2
	movapd	%xmm2, %xmm0
.L3:
	movsd	(%rdi,%rax,8), %xmm1
	mulsd	(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	movsd	8(%rdi,%rax,8), %xmm1
	mulsd	8(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm2
	addq	$2, %rax
	cmpq	%rax, %rdx
	ja	.L3
.L2:
	addsd	%xmm2, %xmm0
	ret
.L4:
	pxor	%xmm2, %xmm2
	movapd	%xmm2, %xmm0
	jmp	.L2
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
