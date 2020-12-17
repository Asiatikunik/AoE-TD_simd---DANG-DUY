	.text
	.file	"dotprod1.c"
	.globl	dotprod                 # -- Begin function dotprod
	.p2align	4, 0x90
	.type	dotprod,@function
dotprod:                                # @dotprod
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	je	.LBB0_1
# %bb.2:
	cmpq	$3, %rdx
	ja	.LBB0_4
# %bb.3:
	xorpd	%xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.LBB0_11
.LBB0_1:
	xorps	%xmm0, %xmm0
	retq
.LBB0_4:
	movq	%rdx, %rax
	andq	$-4, %rax
	leaq	-4(%rax), %rcx
	movq	%rcx, %r9
	shrq	$2, %r9
	addq	$1, %r9
	movl	%r9d, %r8d
	andl	$1, %r8d
	testq	%rcx, %rcx
	je	.LBB0_5
# %bb.6:
	subq	%r8, %r9
	xorpd	%xmm1, %xmm1
	xorl	%ecx, %ecx
	xorpd	%xmm0, %xmm0
	.p2align	4, 0x90
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	movupd	(%rdi,%rcx,8), %xmm2
	movupd	16(%rdi,%rcx,8), %xmm3
	movupd	32(%rdi,%rcx,8), %xmm4
	movupd	48(%rdi,%rcx,8), %xmm5
	movupd	(%rsi,%rcx,8), %xmm6
	mulpd	%xmm2, %xmm6
	addpd	%xmm1, %xmm6
	movupd	16(%rsi,%rcx,8), %xmm2
	mulpd	%xmm3, %xmm2
	addpd	%xmm0, %xmm2
	movupd	32(%rsi,%rcx,8), %xmm1
	mulpd	%xmm4, %xmm1
	addpd	%xmm6, %xmm1
	movupd	48(%rsi,%rcx,8), %xmm0
	mulpd	%xmm5, %xmm0
	addpd	%xmm2, %xmm0
	addq	$8, %rcx
	addq	$-2, %r9
	jne	.LBB0_7
# %bb.8:
	testq	%r8, %r8
	je	.LBB0_10
.LBB0_9:
	movupd	(%rsi,%rcx,8), %xmm2
	movupd	16(%rsi,%rcx,8), %xmm3
	movupd	(%rdi,%rcx,8), %xmm4
	mulpd	%xmm2, %xmm4
	addpd	%xmm4, %xmm1
	movupd	16(%rdi,%rcx,8), %xmm2
	mulpd	%xmm3, %xmm2
	addpd	%xmm2, %xmm0
.LBB0_10:
	addpd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	unpckhpd	%xmm1, %xmm0    # xmm0 = xmm0[1],xmm1[1]
	addsd	%xmm1, %xmm0
	cmpq	%rdx, %rax
	je	.LBB0_12
	.p2align	4, 0x90
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	movsd	(%rsi,%rax,8), %xmm1    # xmm1 = mem[0],zero
	mulsd	(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	addq	$1, %rax
	cmpq	%rax, %rdx
	jne	.LBB0_11
.LBB0_12:
	retq
.LBB0_5:
	xorpd	%xmm1, %xmm1
	xorl	%ecx, %ecx
	xorpd	%xmm0, %xmm0
	testq	%r8, %r8
	jne	.LBB0_9
	jmp	.LBB0_10
.Lfunc_end0:
	.size	dotprod, .Lfunc_end0-dotprod
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
