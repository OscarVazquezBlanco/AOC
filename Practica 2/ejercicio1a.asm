.data

valor: .word 1
little: .asciiz "Es little endian."
big: .asciiz "Es big endian."

.globl __start
.text
__start:

lb $s0, valor

bne $s0, $zero, little_endian

la $a0, big
li $v0, 4
syscall

j exit

little_endian:

	la $a0, little
	li $v0, 4
	syscall
	
	j exit
	
exit:
	li $v0, 10
	syscall	