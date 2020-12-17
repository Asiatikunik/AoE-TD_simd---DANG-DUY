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
	leaq	-1(%rdx), %rcx
	movl	%edx, %eax
	andl	$3, %eax
	cmpq	$3, %rcx
	jae	.LBB0_8
# %bb.3:
	xorpd	%xmm0, %xmm0
	xorl	%ecx, %ecx
	jmp	.LBB0_4
.LBB0_1:
	xorps	%xmm0, %xmm0
	retq
.LBB0_8:
	subq	%rax, %rdx
	xorpd	%xmm0, %xmm0
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_9:                                # =>This Inner Loop Header: Depth=1
	movsd	(%rdi,%rcx,8), %xmm1    # xmm1 = mem[0],zero
	movsd	8(%rdi,%rcx,8), %xmm2   # xmm2 = mem[0],zero
	mulsd	(%rsi,%rcx,8), %xmm1
	mulsd	8(%rsi,%rcx,8), %xmm2
	addsd	%xmm0, %xmm1
	movsd	16(%rdi,%rcx,8), %xmm3  # xmm3 = mem[0],zero
	mulsd	16(%rsi,%rcx,8), %xmm3
	addsd	%xmm1, %xmm2
	movsd	24(%rdi,%rcx,8), %xmm0  # xmm0 = mem[0],zero
	mulsd	24(%rsi,%rcx,8), %xmm0
	addsd	%xmm2, %xmm3
	addsd	%xmm3, %xmm0
	addq	$4, %rcx
	cmpq	%rcx, %rdx
	jne	.LBB0_9
.LBB0_4:
	testq	%rax, %rax
	je	.LBB0_7
# %bb.5:
	leaq	(%rsi,%rcx,8), %rdx
	leaq	(%rdi,%rcx,8), %rcx
	xorl	%esi, %esi
	.p2align	4, 0x90
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	movsd	(%rcx,%rsi,8), %xmm1    # xmm1 = mem[0],zero
	mulsd	(%rdx,%rsi,8), %xmm1
	addsd	%xmm1, %xmm0
	addq	$1, %rsi
	cmpq	%rsi, %rax
	jne	.LBB0_6
.LBB0_7:
	retq
.Lfunc_end0:
	.size	dotprod, .Lfunc_end0-dotprod
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
	.addrsig
