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
	cmpq	$15, %rdx
	ja	.LBB0_4
# %bb.3:
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.LBB0_11
.LBB0_1:
	vxorps	%xmm0, %xmm0, %xmm0
	retq
.LBB0_4:
	movq	%rdx, %rax
	andq	$-16, %rax
	leaq	-16(%rax), %rcx
	movq	%rcx, %r9
	shrq	$4, %r9
	incq	%r9
	movl	%r9d, %r8d
	andl	$1, %r8d
	testq	%rcx, %rcx
	je	.LBB0_5
# %bb.6:
	subq	%r8, %r9
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vxorpd	%xmm1, %xmm1, %xmm1
	vxorpd	%xmm2, %xmm2, %xmm2
	vxorpd	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	vmovupd	(%rsi,%rcx,8), %ymm4
	vmovupd	32(%rsi,%rcx,8), %ymm5
	vmovupd	64(%rsi,%rcx,8), %ymm6
	vmovupd	96(%rsi,%rcx,8), %ymm7
	vfmadd132pd	(%rdi,%rcx,8), %ymm0, %ymm4 # ymm4 = (ymm4 * mem) + ymm0
	vfmadd132pd	32(%rdi,%rcx,8), %ymm1, %ymm5 # ymm5 = (ymm5 * mem) + ymm1
	vfmadd132pd	64(%rdi,%rcx,8), %ymm2, %ymm6 # ymm6 = (ymm6 * mem) + ymm2
	vfmadd132pd	96(%rdi,%rcx,8), %ymm3, %ymm7 # ymm7 = (ymm7 * mem) + ymm3
	vmovupd	128(%rsi,%rcx,8), %ymm0
	vmovupd	160(%rsi,%rcx,8), %ymm1
	vmovupd	192(%rsi,%rcx,8), %ymm2
	vmovupd	224(%rsi,%rcx,8), %ymm3
	vfmadd132pd	128(%rdi,%rcx,8), %ymm4, %ymm0 # ymm0 = (ymm0 * mem) + ymm4
	vfmadd132pd	160(%rdi,%rcx,8), %ymm5, %ymm1 # ymm1 = (ymm1 * mem) + ymm5
	vfmadd132pd	192(%rdi,%rcx,8), %ymm6, %ymm2 # ymm2 = (ymm2 * mem) + ymm6
	vfmadd132pd	224(%rdi,%rcx,8), %ymm7, %ymm3 # ymm3 = (ymm3 * mem) + ymm7
	addq	$32, %rcx
	addq	$-2, %r9
	jne	.LBB0_7
# %bb.8:
	testq	%r8, %r8
	je	.LBB0_10
.LBB0_9:						
	vmovupd	(%rsi,%rcx,8), %ymm4
	vmovupd	32(%rsi,%rcx,8), %ymm5
	vmovupd	64(%rsi,%rcx,8), %ymm6
	vmovupd	96(%rsi,%rcx,8), %ymm7
	vfmadd231pd	96(%rdi,%rcx,8), %ymm7, %ymm3 # ymm3 = (ymm7 * mem) + ymm3
	vfmadd231pd	64(%rdi,%rcx,8), %ymm6, %ymm2 # ymm2 = (ymm6 * mem) + ymm2
	vfmadd231pd	32(%rdi,%rcx,8), %ymm5, %ymm1 # ymm1 = (ymm5 * mem) + ymm1
	vfmadd231pd	(%rdi,%rcx,8), %ymm4, %ymm0 # ymm0 = (ymm4 * mem) + ymm0
.LBB0_10:						
	vaddpd	%ymm2, %ymm0, %ymm0
	vaddpd	%ymm3, %ymm1, %ymm1
	vaddpd	%ymm1, %ymm0, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vaddpd	%xmm1, %xmm0, %xmm0
	vpermilpd	$1, %xmm0, %xmm1 # xmm1 = xmm0[1,0]
	vaddsd	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %rax
	je	.LBB0_12
	.p2align	4, 0x90
.LBB0_11:                               # =>This Inner Loop Header: Depth=1	//petit opération 
	vmovsd	(%rsi,%rax,8), %xmm1    # xmm1 = mem[0],zero
	vfmadd231sd	(%rdi,%rax,8), %xmm1, %xmm0 # xmm0 = (xmm1 * mem) + xmm0
	incq	%rax
	cmpq	%rax, %rdx
	jne	.LBB0_11
.LBB0_12:
	vzeroupper
	retq
.LBB0_5:						//Initialisation
	vxorpd	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vxorpd	%xmm1, %xmm1, %xmm1
	vxorpd	%xmm2, %xmm2, %xmm2
	vxorpd	%xmm3, %xmm3, %xmm3
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
