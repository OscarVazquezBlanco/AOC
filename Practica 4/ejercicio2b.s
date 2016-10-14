.data

num_hex: .asciiz "FFFFFFFF"

.globl __start
.text
__start:

la $a0, num_hex

jal funcion

add $a0, $v0, $zero

li $v0, 1
syscall

li $v0, 10
syscall		# Fin del programa

funcion:

	li $v0, 0		# Inicializamos a 0 donde vamos a guardar el resultado
	li $s0, 58		# $s0 vamos a utilizarla para distinguir si el caracter es numero o letra (del 48 al 57 son del 0 al 9)
	add $t0, $a0, $zero	# $t0 variable con la que trabajamos, asi dejamos intacto $a0 por si se necesita
	bucle:
		lb $t1, 0($t0)
		beq $t1, $zero, exit_function	# Comprueba si es carácter nulo
		sll $v0, $v0, 4
		addi $t0, $t0, 1
		blt $t1, $s0, numeros
		subi  $t1, $t1, 55	# Esta parte se ejecuta si el caracter es letra (A en ascii es 65, restamos 55 para que quede 10)
		or $v0, $t1, $v0
		j bucle
		
		numeros:
			subi  $t1, $t1, 48	# Esta parte se ejecuta si el caracter es numero (0 en ascii es 48, restamos 48 para que quede 0)
			or $v0, $t1, $v0
			j bucle
			
		exit_function:
			jr $ra
			
			
