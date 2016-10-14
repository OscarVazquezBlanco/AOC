.data

introduce: .asciiz "Introduzca numero hexadecimal: "
cadena_larga: .asciiz "El número hexadecimal es demasiado largo (max. 8 digitos)."
caracter_incorrecto: .asciiz "Algun caracter introducido no esta permitido (permitido: [0-9] [A-F])."
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

li $t1, 1		# Para comprobar cadena larga
li $t2, 2		# Para comprobar caracter incorrecto
beq $v0, $t1, FIN_cadena_larga
beq $v0, $t2, FIN_caracter_incorrecto

FIN_sin_errores:
	
	add $a0, $v1, $zero
	li $v0, 1	
	syscall		# Imprime el resultado
	
	li $v0, 10
	syscall		# Fin del programa


FIN_cadena_larga:
	la $a0, cadena_larga
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall		# Fin del programa
	
FIN_caracter_incorrecto:
	la $a0, caracter_incorrecto
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall		# Fin del programa
	

funcion:

	li $v1, 0		# Inicializamos a 0 donde vamos a guardar el resultado
	li $s0, 58		# $s0 vamos a utilizarla para distinguir si el caracter es numero o letra (del 48 al 57 son del 0 al 9)
	li $s1, 10		# Usamos $s1 para comprobar cuándo llega el salto de línea ('\n')
	li $s2, 9		# Lo usamos como contador para comprobar si se introduce una cadena más larga de 8 caracteres (mas el salto de línea al final)
	li $s3, 48		# Para comprobar carácteres incorrectos por debajo del 0 en ASCII (48)
	li $s4, 58		# Para comprobar si es carácter numérico (se usa para comprobacion_caracter_incorrecto)
	li $s5, 65		# Para comprobar carácteres incorrectos por debajo de la 'A' en ASII (65)
	li $s6, 71		# Para comprobar si es carácter A-F (se usa para comprobacion_caracter_incorrecto)
	add $t0, $a0, $zero	# $t0 variable con la que trabajamos, asi dejamos intacto $a0 por si se necesita
	add $t9, $a0, $zero	# se necesita otra copia para trabajar las comprobaciones
	
	comprobar_longitud:
		beq $s2, $zero, exit_cadena_larga
		subi $s2, $s2, 1
		lb $t1, 0($a0)
		beq $t1, $s1, comprobar_caracter_incorrecto
		addi $a0, $a0, 1
		j comprobar_longitud
		
	comprobar_caracter_incorrecto:
		lb $t1, 0($t9)
		beq $t1, $s1, convierte		# Comprueba si ha llegado el salto de línea, para pasar a convertir a decimal
		blt $t1, $s3, exit_caracter_incorrecto
		blt $t1, $s4, siguiente_caracter
		blt $t1, $s5, exit_caracter_incorrecto
		blt $t1, $s6, siguiente_caracter
		j exit_caracter_incorrecto
		
	siguiente_caracter:	# Se utiliza para sumar +1 a la dirección y poder comprobar el siguiente caracter de la cadena
				# Mientras se comprueba si hay algún carácter no permitido
		addi $t9, $t9, 1
		j comprobar_caracter_incorrecto
	
	convierte:
		lb $t1, 0($t0)
		beq $t1, $s1, exit_sin_error	# Comprueba si es salto de línea para devolver el resultado
		sll $v1, $v1, 4
		addi $t0, $t0, 1
		blt $t1, $s0, numeros
		subi  $t1, $t1, 55	# Esta parte se ejecuta si el caracter es letra (A en ascii es 65, restamos 55 para que quede 10)
		or $v1, $t1, $v1
		j convierte
		
		numeros:
			subi  $t1, $t1, 48	# Esta parte se ejecuta si el caracter es numero (0 en ascii es 48, restamos 48 para que quede 0)
			or $v1, $t1, $v1
			j convierte
		
	exit_cadena_larga:
		li $v0, 1
		jr $ra
		
	exit_caracter_incorrecto:
		li $v0, 2
		jr $ra
		
	exit_sin_error:
		li $v0, 0
		jr $ra
