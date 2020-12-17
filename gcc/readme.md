# AoB TD_simd - DANG DUY.md
# gcc version 9.3.0 
# Ubuntu

Ce devoir maison a pour but de analyser le code assembleur en fonction du compilateur utiliser. Il faut comprendre et trouver les différents flag d'optimisations à la compilation. De plus, il faut aussi dérouler la boucle et remarquer les modifications au niveau assembleur.

Vous trouverez dans le fichier gcc dp1 et dp2 qui sont les dotprod du Devoir Maison. Et un dp3, qui est dérouler une fois de plus que le dp2.
Dans chaque fichier, vous trouvez un dotprod_avecSonOptimisation.s 

Vous pouvez recompiler avec le makefile.

Les fichiers sont `dotprof<derouler>_<optimisation>.s`


```C
double dotprod(double *restrict a, double *restrict b, unsigned long long n) {
	
	double d = 0.0;
 
    for (unsigned long long i = 0; i<n; i++)
        d += a[i] * b [i];
 
    return d;
}
```

## dotprod1_O1.s
*Ici, je met java, pour les couleurs, c'est le moins pire de ceux que j'ai trouvé, sinon, j'utilise MIPS sur sublime text.*
```java
dotprod:
.LFB0:
	.cfi_startproc
	endbr64
	testq	%rdx, %rdx
	je	.L4
	movl	$0, %eax
	pxor	%xmm1, %xmm1
.L3:
	movsd	(%rdi,%rax,8), %xmm0
	mulsd	(%rsi,%rax,8), %xmm0
	addsd	%xmm0, %xmm1
	addq	$1, %rax
	cmpq	%rax, %rdx
	jne	.L3
.L1:
	movapd	%xmm1, %xmm0
	ret
.L4:
	pxor	%xmm1, %xmm1
	jmp	.L1
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
```

## Explications

Les .LFB0 et .LFE0 ne sont que des labels locaux.

### LFBO les instructions rencontré
Pour commencer, vu que je ne sais pas où je m'aventure, je cherche a comprendre un peu ce qui se passe donc je prends des mots de l'assembleur et je cherche sur internet.

Vu qu'on est sur un environnement unix, % se retrouve devant un registre et $ est une valeurs constantes.
Pour copier un nombre dans un registre nous avons, "OPERATION SOURCE, DESTINATION" vu que je suis dans un environnement unix.

Toutes les cibles de branch indirecte doivent commencer par endbr64.

RAX, EAX, AX, AL impliquent qword (64 bits), long (double word, 32bits), word (16bits) et byte (octet 8 bits)

.cfi_startproc est utilisé au début de chaque fonction.

.cfi_endproc est la fin de la fonction.

	( Les .cfi sont des directives qui entraine de la génération de données supplémentaires par le compilateur. Les données généré aident à parcourir la pile d'appels lorsqu'un instruction provoque une exception, de sorte que le gestionnaire d'exceptions peut-être trouvé et correctement exécuté. Les informations de la pile d'appels sont utilses pour le débogage. )

testq test bit à bit avec "et logique" les deux registres l'un après l'autre.

%rax contient la valeur de retour. (Ou %rax et %rdx contient la valeur de retour si la taille est entre 8 octets et 16 octects).

%rsp pointe sur les arguments poussés par l'appelant qui ne rentrant pas dans les six registres utilisés pour passer des arguments sur amd64 (%rdi, %rsi, %rdx)

pxor fait un "ou exclusif" sur les paramètres.


#### LFBO Explications
Il commence donc à faire un "et logique" bit à bit sur rdx qui sont des registres sur rdx et met le flag ZF (Zero Flag) à 1 si rdx vaut 0.
Le flag ZF est un indicateur positionné à 1 si les deux opérandes utilisés sont égaux, sinon positionné à 0. Donc si rdx est égal à 0 on met le flag ZF à 0.

rdx est le registre de la variable n de la boucle for.

`je .L4` c'est un jump avec une condition, on voit si le flag ZF est égal à 1, si c'est le cas, alors on saute le label L4.

`movl	$0, %eax` eax est un registre accumulateur qui est utilisé pour les opérations arithmétiques et le stockage de la valeur de retour des appels systèmes. Ici, il est initialisé à 0.

La dernière ligne, `pxor	%xmm1, %xmm1` à pour but d'initialisée notre variables. Ici, on fait un "ou exclusif", (il faut savoir que si on fait un XOR de deux nombres identiques, nous retrouvons alors une séquence de 0). 
Donc ici, nous avons 0 comme pour notre variable b.

J'ai essaye de mettre la variable d=1.0 est nous avons `movl	$0, %eax`. Ce qui prouve que c'est bien l'initialisation des variables. Comme pour les lignes qui suivent, il va cherché a toutes les initiatisé comme pour les autres fichiers dotplot avec plus de variable.

####L3

`movsd	(%rdi,%rax,8), %xmm0`
On instancie les registes, rax est multiplié par 8 parce qu'on utilise un double. Si on utilise un int, par exemple, on aurait 4.

`mulsd	(%rsi,%rax,8), %xmm0`
On met dans le registre a[i] dans xmm0.

`addsd	%xmm0, %xmm1`
On ajoute xmm0 à xmm1, donc on fait d += a[i] * b[i]

`addq	$1, %rax`
On incrémente l'indice rax à 1.

`cmpq	%rax, %rdx`
On compare i à n

`jne	.L3`
Si n est différent de n, on va a .L3.
Dans le code en langage C, on vérifie plutot que i est inférieur à n.
Donc, on refait un tour de boucle.


####L1
`movapd	%xmm1, %xmm0`
On affecte la valeur de xmm1 dans xmm0
`ret`
Cette instruction permet de quitter une procédure.

####L4
`pxor	%xmm1, %xmm1`
On met xmm1 à 0 vu qu'on fait un "ou exclusif" du même nombre.

`jmp	.L1`
C'est un jump donc on fait la suite d'instruction L1.

`.cfi_endproc`
Fin de la fonction.

####Le reste

`.size	dotprod, .-dotprod`
Certaines cibles exigent que GCC suive la taille de chaque instruction utilisée afin de générer un code correct. Comme la longueur finale du code produit par une instruction asm n'est connue que par l'assembleur, GCC doit faire une estimation de sa taille.

`.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"`
Pour dire la version de gcc que j'utilise et sur quel environnement je travail.

##### Conclusion
Si n=0 alors on ne rentre pas dans la boucle.

## dotprod1_O2.s
```java
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
	movl	$1, %r8d
	.p2align 4,,10
	.p2align 3
.L3:
	movl	(%rdi,%rax,4), %ecx
	imull	(%rsi,%rax,4), %ecx
	addq	$1, %rax
	addl	%ecx, %r8d
	cmpq	%rax, %rdx
	jne	.L3
	movl	%r8d, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	movl	$1, %r8d
	movl	%r8d, %eax
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
```
### Les différances entre le dotprod1_O1.s et dotprod1_O2.s
*Je vais essayé de seulement dire les différances notoire entre les deux fichiers, pour ne pas me répéter.*

On peut remarqué plusieurs optimisation. 
Il n'y a pas de .L1.
Mais en réalisé, on a déplacer le contunue de .L1 dans l4, comme cela, on évite de faire des tours.

#### LFB0
`.p2align 4`
C'est pour l'alignement de puissance de deux octets. Elle s'aligner sur une limite de 16 octets. 
Exemple, si on aurait `.p2align 5` on aurait une limite de 32 octets.
Ainsi de suite.

`xorl	%eax, %eax` <- `movl	$0, %eax`
On peut remarqué que faire un "ou exclusif" et plus optimiser que que movl.

`addq	$1, %rax`
On incrémente l'indice rax à 1, un peu plus tôt, je suppose que vu que juste avant on utilise le registre, il est bon de le modifié directement, plutôt que aller faire quelque chose d'autre et retournée le chercher.

#### Conclusion
Il y a moins d'instruction et on remplace par des instruction équivalentes mais mieux optimisé.
Il y a une gestion des dépendances.



##  dotprod1_O3.s
```java
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
	je	.L7
	cmpq	$1, %rdx
	je	.L8
	movq	%rdx, %rcx
	movsd	.LC0(%rip), %xmm0
	xorl	%eax, %eax
	shrq	%rcx
	salq	$4, %rcx
	.p2align 4,,10
	.p2align 3
.L4:
	movupd	(%rdi,%rax), %xmm1
	movupd	(%rsi,%rax), %xmm3
	addq	$16, %rax
	mulpd	%xmm3, %xmm1
	movapd	%xmm1, %xmm2
	unpckhpd	%xmm1, %xmm1
	addsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	addsd	%xmm2, %xmm0
	cmpq	%rax, %rcx
	jne	.L4
	movq	%rdx, %rax
	andq	$-2, %rax
	andl	$1, %edx
	je	.L11
.L3:
	movsd	(%rsi,%rax,8), %xmm1
	mulsd	(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L11:
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	movsd	.LC0(%rip), %xmm0
	ret
.L8:
	movsd	.LC0(%rip), %xmm0
	xorl	%eax, %eax
	jmp	.L3
	.cfi_endproc
.LFE0:
	.size	dotprod, .-dotprod
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
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

```

### Les différances entre le dotprod1_O2.s et dotprod1_O3.s

*Je vais continué dans l'idée de ne pas reécrire ce que j'ai déjà écrit. Et seulement notifié les différance.*

On peut déjà remarqué qu'il y a déjà beaucoup plus de chose en passant a l'optimisation -03.


#### LFB0
`
testq	%rdx, %rdx
je	.L7
cmpq	$1, %rdx
je	.L8
`
On voit que vérifie si le registre est égale a 0, il fait L7.
S'il est égal à 1, on ne fait qu'un tour de boucle. Alors d = a[0] * b[b]

`movq	%rdx, %rcx`
On copie le registre à rdx dans rcx.

`movsd	.LC0(%rip), %xmm0`
Ici, l'optimisation est sur le registre rip (re-extended instruction pointer), c'est une instruction de taille variables, le registre est automatiquement augmentée lors de l'excécution afin que le registre pointe sur le registre suivant.

`shrq	%rcx`
Cette instruction permet de faire un décalage de bit vers la droite.
On fait ça pour évité une erreur de segmentation. Dans le cas, où c'est impair.

`salq	$4, %rcx`
Cette instruction permet d'effectuer une rotation des bits vers la gauche en réinsérant le bit dans l'indicateur de retenue (CF).
C'est en quelque sorte une décalage de bit vers la gauche de 4.


Le décalage vers la gauche de 4 sur une base 2, c'est comme si on multiplié par 2³=8.
On multiplie n x 8, en retirant le bit de point faible pour évité l'erreur de segmentation.
On multiplie par 8 parce que c'est la taille de a.
On fait tout ça pour trouver l'adresse de la case qui est un double, ici dans notre cas, on arrête la boucle quand rax vaut la taille du tableau.



#### L4
`
movupd	(%rdi,%rax), %xmm1
movupd	(%rsi,%rax), %xmm3
`
Alors ici, c'est un peu bizarre mais on enregistre 2 registre dans 1. 
*J'ai pris du temps a comprendre mais j'ai essayé de voir sur le site la différance.*
mais xmm1 et xmm3 est en 128bits soit 16 octects, comme ça il a la possibilité de prendre les deux.
Soit "a[i] et a[i+1]" et "b[i] et b[i+1]"


`addq	$16, %rax`
On fait i+2

`
mulpd	%xmm3, %xmm1
movapd	%xmm1, %xmm2
unpckhpd	%xmm1, %xmm1
addsd	%xmm0, %xmm2
movapd	%xmm1, %xmm0
addsd	%xmm2, %xmm0
`
Si je comprends bien, le but est de multiplié "a[i] et b[i]"" et "a[i+1] et b[i+1]"
unpckhpd échange les 8 octets avec les 8 suivants
On multiplie les 8 octest, on switch et on multiplie le reste.
	
`	
cmpq	%rax, %rcx
jne	.L4
`
On compare l'adresse où on se trouve avec la taille du tableau.
Si on n'est pas encore a la fin du tableau on continue.

`
movq	%rdx, %rax
andq	$-2, %rax
andl	$1, %edx
je	.L11
`
Ici, on regard si dans le cas ou le n de la boucle est impair, dans ce cas la, on fait le dernier tour de boucle qui est a[n-1] * b[n-1]
Pour cela, on vérifier le bit de poids faible.
-2 parce que c'est le nombre maximal sur 8 octets -1.
C'est pour récupérer le bit de poids faible et le mettre dans rax.

#### L3 L7 L8
Ici on fait des opération si la taille du tableau est impair.

#### Conclusion
L'idée est de prendre des cases mémoire plus grande et donc diviser en deux le nombre d'opération, étant donnée qu'on fait les tours de boucle par 2.
Mais alors, il faut faire attention, au cas si la boucle est n=1 et s'il est impair, c'est pour ça que l'assembleur et beaucoup plus gros que les autres optimisations.


## fotprod1_0fast.s
```java
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
	je	.L7
	cmpq	$1, %rdx
	je	.L8
	movq	%rdx, %rcx
	xorl	%eax, %eax
	pxor	%xmm0, %xmm0
	shrq	%rcx
	salq	$4, %rcx
	.p2align 4,,10
	.p2align 3
.L4:
	movupd	(%rdi,%rax), %xmm1
	movupd	(%rsi,%rax), %xmm2
	addq	$16, %rax
	mulpd	%xmm2, %xmm1
	addpd	%xmm1, %xmm0
	cmpq	%rax, %rcx
	jne	.L4
	movq	%rdx, %rax
	movapd	%xmm0, %xmm1
	unpckhpd	%xmm0, %xmm1
	andq	$-2, %rax
	andl	$1, %edx
	addpd	%xmm0, %xmm1
	je	.L1
.L3:
	movsd	(%rsi,%rax,8), %xmm0
	mulsd	(%rdi,%rax,8), %xmm0
	addsd	%xmm0, %xmm1
.L1:
	movapd	%xmm1, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	pxor	%xmm1, %xmm1
	movapd	%xmm1, %xmm0
	ret
.L8:
	xorl	%eax, %eax
	pxor	%xmm1, %xmm1
	jmp	.L3
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
```
### Les différances entre le dotprod1_O3.s et dotprod1_Ofast.s

#### L4
On voit que le `jne	.L4` se fait plus tot, donc il y a moins d'instruction par tour de boucle.
Il fait fini l'addition en dehors de la boucle afin de gagner en performance.
A chaque tour de boucle, il met tout dans %xmm0, c'est seulement en sortant de la boucle qu'il fait l'addition entre les deux parties.



##dotprod1_kamikaze.s
```java
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
	je	.L7
	leaq	-1(%rdx), %rax
	cmpq	$2, %rax
	jbe	.L8
	movq	%rdx, %r8
	shrq	$2, %r8
	salq	$5, %r8
	leaq	-32(%r8), %rcx
	shrq	$5, %rcx
	incq	%rcx
	xorl	%r9d, %r9d
	vxorpd	%xmm0, %xmm0, %xmm0
	andl	$7, %ecx
	je	.L4
	cmpq	$1, %rcx
	je	.L31
	cmpq	$2, %rcx
	je	.L32
	cmpq	$3, %rcx
	je	.L33
	cmpq	$4, %rcx
	je	.L34
	cmpq	$5, %rcx
	je	.L35
	cmpq	$6, %rcx
	jne	.L49
.L36:
	vmovupd	(%rdi,%r9), %ymm3
	vfmadd231pd	(%rsi,%r9), %ymm3, %ymm0
	addq	$32, %r9
.L35:
	vmovupd	(%rdi,%r9), %ymm4
	vfmadd231pd	(%rsi,%r9), %ymm4, %ymm0
	addq	$32, %r9
.L34:
	vmovupd	(%rdi,%r9), %ymm5
	vfmadd231pd	(%rsi,%r9), %ymm5, %ymm0
	addq	$32, %r9
.L33:
	vmovupd	(%rdi,%r9), %ymm6
	vfmadd231pd	(%rsi,%r9), %ymm6, %ymm0
	addq	$32, %r9
.L32:
	vmovupd	(%rdi,%r9), %ymm1
	vfmadd231pd	(%rsi,%r9), %ymm1, %ymm0
	addq	$32, %r9
.L31:
	vmovupd	(%rdi,%r9), %ymm7
	vfmadd231pd	(%rsi,%r9), %ymm7, %ymm0
	addq	$32, %r9
	cmpq	%r8, %r9
	je	.L45
.L4:
	vmovupd	(%rdi,%r9), %ymm8					
	vmovupd	32(%rdi,%r9), %ymm9					
	vfmadd231pd	(%rsi,%r9), %ymm8, %ymm0  		//Il fait laddition directement sur le registre
	vmovupd	64(%rdi,%r9), %ymm10
	vmovupd	96(%rdi,%r9), %ymm11
	vmovupd	128(%rdi,%r9), %ymm12
	vmovupd	160(%rdi,%r9), %ymm13
	vfmadd231pd	32(%rsi,%r9), %ymm9, %ymm0   	//multiplication et addition multiplier chaque double 
	vmovupd	192(%rdi,%r9), %ymm14				
	vmovupd	224(%rdi,%r9), %ymm15
	vfmadd231pd	64(%rsi,%r9), %ymm10, %ymm0 	
	vfmadd231pd	96(%rsi,%r9), %ymm11, %ymm0
	vfmadd231pd	128(%rsi,%r9), %ymm12, %ymm0
	vfmadd231pd	160(%rsi,%r9), %ymm13, %ymm0
	vfmadd231pd	192(%rsi,%r9), %ymm14, %ymm0
	vfmadd231pd	224(%rsi,%r9), %ymm15, %ymm0
	addq	$256, %r9
	cmpq	%r8, %r9
	jne	.L4
.L45:										
	vextractf128	$0x1, %ymm0, %xmm2
	vaddpd	%xmm0, %xmm2, %xmm3
	movq	%rdx, %r10
	andq	$-4, %r10
	vunpckhpd	%xmm3, %xmm3, %xmm0
	vaddpd	%xmm3, %xmm0, %xmm0
	testb	$3, %dl
	je	.L50
	vzeroupper
.L3:											
	vmovsd	(%rdi,%r10,8), %xmm4
	leaq	1(%r10), %r11
	vfmadd231sd	(%rsi,%r10,8), %xmm4, %xmm0
	cmpq	%r11, %rdx
	jbe	.L47
	vmovsd	(%rdi,%r11,8), %xmm5
	addq	$2, %r10
	vfmadd231sd	(%rsi,%r11,8), %xmm5, %xmm0
	cmpq	%r10, %rdx
	jbe	.L47
	vmovsd	(%rsi,%r10,8), %xmm6
	vfmadd231sd	(%rdi,%r10,8), %xmm6, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	vxorpd	%xmm0, %xmm0, %xmm0
.L47:
	ret
	.p2align 4,,10
	.p2align 3
.L50:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L49:
	vmovupd	(%rdi), %ymm2
	movl	$32, %r9d
	vfmadd231pd	(%rsi), %ymm2, %ymm0
	jmp	.L36
.L8:
	xorl	%r10d, %r10d
	vxorpd	%xmm0, %xmm0, %xmm0
	jmp	.L3
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
```
#### Explication
En gros, il prend 4 doubles a chaque fois soit 256bits.
Dans gcc, s'il y en a moins que 4 tour de n, alors il le complete dans entre L31 et L36
S'il y en a plus, il va dans L3 pour faire le reste des opérations.
Et il va dans L45 pour tout additionnée.


```C
double dotprod_unroll2(double *restrict a, double *restrict b, unsigned long long n) {
	double d1 = 0.0;
	double d2 = 0.0;
	
	for (unsigned long long i = 0; i < n; i += 2) {
		d1 += (a[i]* b[i]);
		d2 += (a[i + 1] * b[i + 1]);
	}
	
	return (d1 + d2);
}
```

##  dotprod2_O1.s
```java
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

```

### Les différances entre le dotprod1_O1.s et dotprod2_O1.s
Normalement, ça va être grossièrement la même chose, mais doublé.

`
pxor	%xmm2, %xmm2
movapd	%xmm2, %xmm0
`
On instancie d1 et d2.
On utilise un movapd parce que les deux valeurs sont a 0.

`
	movsd	(%rdi,%rax,8), %xmm1
	mulsd	(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
`
C'est pour d1

`
	movsd	8(%rdi,%rax,8), %xmm1
	mulsd	8(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm2
`
C'est pour d2
C'est la même chose donc que sur dotprod1 sauf qu'on double.

`addq	$2, %rax`
On incrémente le i de 2 comme dans la boucle

`addsd	%xmm2, %xmm0`
On fait l'addition avant de le retournée.


##  dotprod2_O2.s
```java
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
	je	.L4
	pxor	%xmm2, %xmm2
	xorl	%eax, %eax
	movapd	%xmm2, %xmm0
	.p2align 4,,10
	.p2align 3
.L3:
	movsd	(%rdi,%rax,8), %xmm1
	mulsd	(%rsi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
	movsd	8(%rdi,%rax,8), %xmm1
	mulsd	8(%rsi,%rax,8), %xmm1
	addq	$2, %rax
	addsd	%xmm1, %xmm2
	cmpq	%rax, %rdx
	ja	.L3
	addsd	%xmm2, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	pxor	%xmm0, %xmm0
	ret
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

```
### Les différances entre le dotprod2_O1.s et dotprod2_O2.s
Il y a toujours le `movapd	%xmm2, %xmm0` pour le d2

Il y a toujours cette modification.
`xorl	%eax, %eax` <- `movl	$0, %eax`
On peut remarqué que faire un "ou exclusif" et plus optimiser que que movl.

`addsd	%xmm2, %xmm0`
Cette instruction est sortie de L2

`addq	$2, %rax`
On fait le i+2 un peu plus tot.

On voit les même optimisation rien de très étonnant.


##  dotprod2_O3.s
```java
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
	subq	$1, %rdx
	movq	%rdx, %rcx
	shrq	%rcx
	addq	$1, %rcx
	cmpq	$1, %rdx
	jbe	.L7
	movq	%rcx, %rdx
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	shrq	%rdx
	movapd	%xmm0, %xmm4
	salq	$5, %rdx
	.p2align 4,,10
	.p2align 3
.L4:
	movupd	(%rdi,%rax), %xmm3
	movupd	(%rsi,%rax), %xmm2
	movupd	16(%rdi,%rax), %xmm1
	movlpd	8(%rdi,%rax), %xmm1
	movhpd	16(%rdi,%rax), %xmm3
	movhpd	16(%rsi,%rax), %xmm2
	mulpd	%xmm3, %xmm2
	addsd	%xmm2, %xmm4
	unpckhpd	%xmm2, %xmm2
	addsd	%xmm2, %xmm4
	movupd	16(%rsi,%rax), %xmm2
	movlpd	8(%rsi,%rax), %xmm2
	addq	$32, %rax
	mulpd	%xmm2, %xmm1
	movapd	%xmm1, %xmm2
	unpckhpd	%xmm1, %xmm1
	addsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	addsd	%xmm2, %xmm0
	cmpq	%rdx, %rax
	jne	.L4
	movq	%rcx, %rdx
	andq	$-2, %rdx
	leaq	(%rdx,%rdx), %rax
	cmpq	%rcx, %rdx
	je	.L5
.L3:
	movsd	(%rsi,%rax,8), %xmm1
	mulsd	(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm4
	movsd	8(%rsi,%rax,8), %xmm1
	mulsd	8(%rdi,%rax,8), %xmm1
	addsd	%xmm1, %xmm0
.L5:
	addsd	%xmm4, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	pxor	%xmm0, %xmm0
	ret
.L7:
	pxor	%xmm0, %xmm0
	xorl	%eax, %eax
	movapd	%xmm0, %xmm4
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

```
### Les différances entre le dotprod1_O3.s et dotprod2_O3.s
C'est grossièrement la même optimisation quand on fait 03.

Ce qui est intéressant ce trouve dans L4.
Comment on aurait pu le penser, il aurait pu utiliser 4 registres mais ici, il en utilise que 3 pour faire la boucle, avant de le remettre dans le dernier registre.
Il fait l'addition dans l'un des registres et puis après, il récuperer pour le mettre dans le registre où on a déjà utiliser déplacer les informations.

Dans L3, il double seulement les instructions



##  dotprod2_Ofast.s
```java
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
	je	.L4
	subq	$1, %rdx
	xorl	%eax, %eax
	pxor	%xmm1, %xmm1
	shrq	%rdx
	leaq	1(%rdx), %rcx
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L3:
	movupd	(%rsi,%rax), %xmm0
	movupd	(%rdi,%rax), %xmm3
	addq	$1, %rdx
	addq	$16, %rax
	mulpd	%xmm3, %xmm0
	addpd	%xmm0, %xmm1
	cmpq	%rcx, %rdx
	jb	.L3
	movapd	%xmm1, %xmm4
	movapd	%xmm1, %xmm0
	unpckhpd	%xmm4, %xmm4
	addsd	%xmm4, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	pxor	%xmm0, %xmm0
	ret
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

```
### Les différances entre le dotprod2_O3.s et dotprod2_Ofast.s


#### L4
Comme pour cette optimisation, on voit qu'il y a moins de chose dans la boucle et donc moins d'excécution.
De plus, il y a beaucoup moins d'instruction.

### Les différances entre le dotprod1_Ofast.s et dotprod2_Ofast.s
La aussi, il y a moins d'instruction, parce qu'il n'utilise que 2 registres à la place des 3.
Et il font l'addition à la fin ce qui permet de gagner en perf.







##  dotprod2_O3.s
```java
```
### Les différances entre le dotprod2_O2.s et dotprod2_O3.s