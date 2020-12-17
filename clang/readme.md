# AoB TD_simd - DANG DUY.md
# clang version 10.0.0-4ubuntu1 
# Ubuntu

C'est la suite, mais ici, je vais traité clang comme vous l'auriez deviné.

```C
double dotprod(double *restrict a, double *restrict b, unsigned long long n) {
	
	double d = 0.0;
 
    for (unsigned long long i = 0; i<n; i++)
        d += a[i] * b [i];
 
    return d;
}
```

## dotprod1_O1.s
```java
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

```
### Explication
Il a l'air d'avoir moins de redondances que dans gcc, parce que on met directement la valeur est directement dans xmm0.

#### %bb.0
`xorpd	%xmm0, %xmm0` 
d est mit a 0.

`
testq	%rdx, %rdx
je	.LBB0_3
`
testq test bit à bit avec "et logique" les deux registres l'un après l'autre.
On voit que vérifie si le registre est égale a 0, il fait LBB0_3.
S'il est égal à 1, on ne fait qu'un tour de boucle. Alors d = a[0] * b[b]

#### LBB0_2
C'est ma boucle for.

`
movsd	(%rdi,%rax,8), %xmm1    # xmm1 = mem[0],zero
mulsd	(%rsi,%rax,8), %xmm1
`
On instancie les registre, et on multiplie par 8 parce qu'on a des doubles. On aurait un 4 si on aurait un int.
Et on le met dans a[i]

`
addsd	%xmm1, %xmm0
addq	$1, %rax
`
On ajoute xmm1 a xmm0.
On fait d+= a[i] * b[i]


`
cmpq	%rax, %rdx
jne	.LBB0_2
`
On compare i à n
Si n est différent de n, on va faire LBBO_2.
Dans le langage c, on vérifie plutot si i est inférieur à n
Donc on refait un tour de boucle.

## dotprod1_O2.s
```java
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

```
### Explication différence entre dotprod1_O1.s et dotprod1_O2.s

`	
testq	%rdx, %rdx
je	.LBB0_1
`
Si n=0, on fait LBB0_1

`
leaq	-1(%rdx), %rcx
`
rcx -> n-1

`
movl	%edx, %eax
`
eax <- edx 

`
andl	$3, %eax
cmpq	$3, %rcx
jae	.LBB0_8
`
On saute si n >= 3

#### LBB0_9
Je ne comprennais pas pourquoi 3.
Mais maitenant oui, avec ce qui va suivre.
`
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
`
On instancie les registre, et on multiplie par 8 parce qu'on a des doubles. On aurait un 4 si on aurait un int.
Ici, on ne fait pas un par un, mais 4 par 4, pour réduire le nombre de jump dans le code.
D'où le fait qu'on vérifie si n>=3 dans ce qu'il y a au-dessus.


## dotprod1_O3.s
```java
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

```
### Explication dotprod1_02 et  dotprod1_03
C'est exactement là même chose, donc, ce code ne peut pas être plus optimiser avec le flag -03.


## dotprod1_Ofast.s
```java
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

```
### Explication
*J'ai remarqué que le code est ressemblant au gcc pour le flag fast. Je vais pas commenté le code pour me faire gagner du temps, parce que finalement, c'est encore plus ou moins la même chose.*

On garde la même idée que l'optimisation -03.
Sauf que a priorie, on irait encore deux fois plus vite parce que, on prend des registres doubles.
c'est-à-dire, "a[i] et a[i+1]" et  "b[i] et b[i+1]" comme pour le fast de gcc.
Alors a la place d'avancer de 4, on avance de 8.


## dotprod1_kamikaze.s
```java
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
.LBB0_11:                               # =>This Inner Loop Header: Depth=1	
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
```
### Explication
Comme dans GCC, il prends 4 doubles sur un registre, il avance donc de 256bits.
L'initialisation se trouve dans LBB0_5.
Ici, c'est un peu plus simple parce que il a une petit boucle LBB0_11 qui lui permet de faire les petits tour de boucle manquant, si jamais n est inférieur à 4. Et, s'il en reste moins que 4 une fois les tours de boucle fait.
