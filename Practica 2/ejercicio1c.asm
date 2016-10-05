.data

etiqueta: .word -1550

positivo: .asciiz "Es positivo"
negativo: .asciiz "Es negativo"

.globl __start
.text

__start:

la $t0,etiqueta

addi $t0,$t0,3

lb $s0,0($t0)

andi $s0,$s0,0x1000
bne $s0,$zero,es_negativo

la $a0,positivo
li $v0,4
syscall

b fin

es_negativo:

la $a0,negativo
li $v0,4
syscall

fin:

li $v0,10
syscall
