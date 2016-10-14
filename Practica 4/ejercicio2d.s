.data

introduce: .asciiz "Introduzca numero hexadecimal: "
cadena: .space 55

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall

la $a0, cadena
li $a1, 50
li $v0, 8
syscall

jal funcion

add $t5, $v0, $zero # Metemos el resultado en $t5 para utilizarlo después

li $a0, 10	# Metemos en $a0 el carácter ASCII de nueva línea
li $v0, 11	# Funcion de print-char
syscall		# Hace un salto de línea, así el resultado no se imprime seguido de lo anterior

add $a0, $t5, $zero
li $v0, 1	
syscall		# Imprime el resultado

li $v0, 10
syscall		# Fin del programa

funcion:

	li $v0, 0		# Inicializamos a 0 donde vamos a guardar el resultado
	li $s0, 58		# $s0 vamos a utilizarla para distinguir si el caracter es numero o letra (del 48 al 57 son del 0 al 9)
	li $s1, 10		# Usamos $s1 para comprobar cuándo llega el salto de línea ('\n')
	add $t0, $a0, $zero	# $t0 variable con la que trabajamos, asi dejamos intacto $a0 por si se necesita
	bucle:
		lb $t1, 0($t0)
		beq $t1, $s1, exit_function	# Comprueba si es salto de línea
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
			sll $v0, $v0, 2
			jr $ra
			
			
