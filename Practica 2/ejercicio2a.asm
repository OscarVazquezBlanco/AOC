.data

matriz: .word -11, 12, -13, 14, -21, 22, -23, 24, -31, 32, -33, 34, -41, 42, -43, 44

.globl __start
.text
__start:

li $s6, 0 	# iterante inicial
li $s7, 16 	# iterante final
li $s0, 0	# inicializamos suma total a 0
la $t0, matriz	# direccion matriz

bucle_filas:

	sll $t5, $s6, 2
	add $t1, $t0, $t5
	lw $t2, 0($t1)	# valor del elemento actual matriz
	add $s0, $s0, $t2 # en $s0 se va acumulando el valor de la suma
	addi $s6, $s6, 1
	bne $s6, $s7, bucle_filas

add $a0, $zero, $s0
li $v0, 1
syscall

li $v0, 10
syscall		#exit