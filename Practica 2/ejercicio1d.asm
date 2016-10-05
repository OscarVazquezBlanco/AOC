.data

simple: .float -1.0
doble: .double -1.0

positivo: .asciiz "Es positivo\n"
negativo: .asciiz "Es negativo\n"

.globl __start
.text

__start:

la $t0,simple

addi $t0,$t0,3


lb $s0,0($t0)

andi $t0,$s0,0x1000


bne $t0,$zero,es_negativo


la $a0,positivo
li $v0,4
syscall

continua:

la $t1,doble

addi $t1,$t1,7

lb $s1,0($t1)

andi $t1,$s1,0x1000

beq $t1,$zero,es_positivo

la $a0,negativo
li $v0,4
syscall

sigue:




li$v0,10
syscall








es_negativo:

la $a0,negativo
li $v0,4
syscall

b continua

es_positivo:

la $a0,positivo
li $v0,4
syscall

b sigue