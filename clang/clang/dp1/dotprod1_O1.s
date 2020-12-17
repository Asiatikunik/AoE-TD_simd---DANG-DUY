	.text
	.file	"dotprod1.c"
	.globl	dotprod                 # -- Begin function dotprod
	.p2align	4, 0x90
	.type	dotprod,@function
dotprod:                                # @dotprod
	.cfi_startproc
# %bb.0:
	xorpd	%xmm0, %xmm0
	testq	%rdx, %rdx
	je	.LBB0_3
# %bb.1:
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	movsd	(%rdi,%rax,8), %xmm1    # xmm1 = mem[0],zero
	mulsd	(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	addq	$1, %rax
	cmpq	%rax, %rdx
	jne	.LBB0_2
.LBB0_3:
	retq
.Lfunc_end0:
	.size	dotprod, .Lfunc_end0-dotprod
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
