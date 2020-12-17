	.text
	.file	"dotprod2.c"
	.globl	dotprod_unroll2         # -- Begin function dotprod_unroll2
	.p2align	4, 0x90
	.type	dotprod_unroll2,@function
dotprod_unroll2:                        # @dotprod_unroll2
	.cfi_startproc
# %bb.0:
	xorpd	%xmm1, %xmm1
	testq	%rdx, %rdx
	je	.LBB0_3
# %bb.1:
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	movupd	(%rdi,%rax,8), %xmm0
	movupd	(%rsi,%rax,8), %xmm2
	mulpd	%xmm0, %xmm2
	addpd	%xmm2, %xmm1
	addq	$2, %rax
	cmpq	%rdx, %rax
	jb	.LBB0_2
.LBB0_3:
	movapd	%xmm1, %xmm0
	unpckhpd	%xmm1, %xmm0    # xmm0 = xmm0[1],xmm1[1]
	addsd	%xmm1, %xmm0
	retq
.Lfunc_end0:
	.size	dotprod_unroll2, .Lfunc_end0-dotprod_unroll2
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
