	.text
	.file	"dotprod2.c"
	.globl	dotprod_unroll2         # -- Begin function dotprod_unroll2
	.p2align	4, 0x90
	.type	dotprod_unroll2,@function
dotprod_unroll2:                        # @dotprod_unroll2
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	je	.LBB0_1
# %bb.3:
	xorpd	%xmm1, %xmm1
	xorl	%eax, %eax
	xorpd	%xmm0, %xmm0
	.p2align	4, 0x90
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	movsd	(%rdi,%rax,8), %xmm2    # xmm2 = mem[0],zero
	movsd	8(%rdi,%rax,8), %xmm3   # xmm3 = mem[0],zero
	mulsd	(%rsi,%rax,8), %xmm2
	mulsd	8(%rsi,%rax,8), %xmm3
	addsd	%xmm2, %xmm0
	addsd	%xmm3, %xmm1
	addq	$2, %rax
	cmpq	%rdx, %rax
	jb	.LBB0_4
# %bb.2:
	addsd	%xmm1, %xmm0
	retq
.LBB0_1:
	xorpd	%xmm0, %xmm0
	xorpd	%xmm1, %xmm1
	addsd	%xmm1, %xmm0
	retq
.Lfunc_end0:
	.size	dotprod_unroll2, .Lfunc_end0-dotprod_unroll2
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
