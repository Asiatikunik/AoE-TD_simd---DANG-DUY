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
	decq	%rdx
	movq	%rdx, %rcx
	shrq	%rcx
	incq	%rcx
	cmpq	$1, %rdx
	jbe	.L7
	movq	%rcx, %r8
	shrq	%r8
	salq	$5, %r8
	leaq	-32(%r8), %rdx
	shrq	$5, %rdx
	incq	%rdx
	xorl	%eax, %eax
	vxorpd	%xmm0, %xmm0, %xmm0
	andl	$7, %edx
	je	.L4
	cmpq	$1, %rdx
	je	.L30
	cmpq	$2, %rdx
	je	.L31
	cmpq	$3, %rdx
	je	.L32
	cmpq	$4, %rdx
	je	.L33
	cmpq	$5, %rdx
	je	.L34
	cmpq	$6, %rdx
	jne	.L48
.L35:
	vmovupd	(%rsi,%rax), %ymm6
	vfmadd231pd	(%rdi,%rax), %ymm6, %ymm0
	addq	$32, %rax
.L34:
	vmovupd	(%rsi,%rax), %ymm7
	vfmadd231pd	(%rdi,%rax), %ymm7, %ymm0
	addq	$32, %rax
.L33:
	vmovupd	(%rsi,%rax), %ymm1
	vfmadd231pd	(%rdi,%rax), %ymm1, %ymm0
	addq	$32, %rax
.L32:
	vmovupd	(%rsi,%rax), %ymm2
	vfmadd231pd	(%rdi,%rax), %ymm2, %ymm0
	addq	$32, %rax
.L31:
	vmovupd	(%rsi,%rax), %ymm4
	vfmadd231pd	(%rdi,%rax), %ymm4, %ymm0
	addq	$32, %rax
.L30:
	vmovupd	(%rsi,%rax), %ymm5
	vfmadd231pd	(%rdi,%rax), %ymm5, %ymm0
	addq	$32, %rax
	cmpq	%r8, %rax
	je	.L44
.L4:
	vmovupd	(%rsi,%rax), %ymm8
	vmovupd	32(%rsi,%rax), %ymm9
	vfmadd231pd	(%rdi,%rax), %ymm8, %ymm0
	vmovupd	64(%rsi,%rax), %ymm10
	vmovupd	96(%rsi,%rax), %ymm11
	vmovupd	128(%rsi,%rax), %ymm12
	vmovupd	160(%rsi,%rax), %ymm13
	vfmadd231pd	32(%rdi,%rax), %ymm9, %ymm0
	vmovupd	192(%rsi,%rax), %ymm14
	vmovupd	224(%rsi,%rax), %ymm15
	vfmadd231pd	64(%rdi,%rax), %ymm10, %ymm0
	vfmadd231pd	96(%rdi,%rax), %ymm11, %ymm0
	vfmadd231pd	128(%rdi,%rax), %ymm12, %ymm0
	vfmadd231pd	160(%rdi,%rax), %ymm13, %ymm0
	vfmadd231pd	192(%rdi,%rax), %ymm14, %ymm0
	vfmadd231pd	224(%rdi,%rax), %ymm15, %ymm0
	addq	$256, %rax
	cmpq	%r8, %rax
	jne	.L4
.L44:
	vmovapd	%xmm0, %xmm3
	vunpckhpd	%xmm0, %xmm0, %xmm7
	movq	%rcx, %r9
	vextractf128	$0x1, %ymm0, %xmm0
	vunpckhpd	%xmm0, %xmm0, %xmm4
	andq	$-2, %r9
	vaddsd	%xmm0, %xmm3, %xmm2
	vaddsd	%xmm4, %xmm7, %xmm8
	leaq	(%r9,%r9), %r10
	cmpq	%rcx, %r9
	je	.L49
	vzeroupper
.L3:
	vmovsd	(%rsi,%r10,8), %xmm5
	vmovsd	8(%rsi,%r10,8), %xmm9
	vfmadd231sd	(%rdi,%r10,8), %xmm5, %xmm2
	vfmadd231sd	8(%rdi,%r10,8), %xmm9, %xmm8
	vaddsd	%xmm2, %xmm8, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L49:
	vzeroupper
	vaddsd	%xmm2, %xmm8, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L48:
	vmovupd	(%rsi), %ymm3
	movl	$32, %eax
	vfmadd231pd	(%rdi), %ymm3, %ymm0
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L6:
	vxorpd	%xmm0, %xmm0, %xmm0
	ret
.L7:
	vxorpd	%xmm8, %xmm8, %xmm8
	xorl	%r10d, %r10d
	vmovapd	%xmm8, %xmm2
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
