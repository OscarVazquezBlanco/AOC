.data

f: .word   45
G: .word   10    24    55   67    89    90     110
H: .space   100
cadena: .asciiz "  "

.globl __start
.text
__start:


lui $t0,0x1001
ori $t0,$t0,0x0000


lui $t1,0x1001
ori $t1,$t1,0x0004

lui $t2,0x1001
ori $t2,$t2,0x0020


addi $s0 ,$zero,0 #contador
addi $s1,$zero,7 #limite

add $t4,$zero,$zero # posición en G
add $t5,$zero,$zero #posicion en H

bucle:

	sll $t8,$s0,2

	add $t4,$t1,$t8

	add $t5,$t2,$t8

	lw $t6,0($t4)

	lw $t9,0($t0)

	add $t6,$t6,$t9

	sw $t6,0($t5)
	
	addi $s0,$s0,1

bne $s0,$s1,bucle

add $s0,$zero,$zero



imprimir:

	sll $t8,$s0,2

	add $t5,$t2,$t8

	lw $a0,0($t5)


	lui $v0,0x0000
	ori $v0,$v0,0x0001	

	syscall


	lw $t0,cadena
	or $t0,$t0,$t0

	
	lui $v0,0x0000
	ori $v0,$v0,0x0004
	syscall

	addi $s0,$s0,1

bne $s0,$s1,imprimir


lui $v0,0x000a
ori $v0,$v0,0x000a
syscall
