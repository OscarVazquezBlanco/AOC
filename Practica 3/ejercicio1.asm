# Este es el ejericio 1 y ejercicio 2 a) juntos
.data

Ox: .asciiz "0x"
introduce: .asciiz "Introduzca numero: "
num_hex: .space 8

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall

li $v0, 5
syscall

add $a0, $v0, $zero

add $s6, $zero, $zero 	# iterador inicial
add $s7, $zero, 8 	# iterador final

la $a1, num_hex

jal funcion

la $a0, Ox
li $v0, 4
syscall

la $a0, num_hex
li $v0, 4
syscall

li $v0, 10
syscall		# exit

funcion:

	add $t0, $a0, $zero
	bucle:
		andi $t1, $t0, 0xF0000000
		srl $t1, $t1, 28
		li $s0, 10
		blt $t1, $s0, numeros
		addi $t1, $t1, 55
		sb $t1, 0($a1)
		addi $a1, $a1, 1
		sll $t0, $t0, 4
		addi $s6, $s6, 1
		bne $s6, $s7, bucle

		jr $ra
	
	numeros:
		addi $t1, $t1, 48
		sb $t1, 0($a1)
		addi $a1, $a1, 1
		sll $t0, $t0, 4
		addi $s6, $s6, 1
		bne $s6, $s7, bucle
	
		jr $ra
