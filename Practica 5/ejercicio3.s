.data

introduce: .asciiz "Introduzca numero decimal: "
decimal: .space 20

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall

la $a0, decimal
li $a1, 20
li $v0, 8
syscall

jal funcion

add $a0, $v1, $zero
li $v0, 1
syscall		# Imprime resultado

li $v0, 10
syscall		# Fin del programa

funcion:
	add $s3, $a0, $zero	# Guardamos direccion inicial de $a0 en $s3 para utilizarla en caso aislado de comprobar_caracteres
	li $v0, 0		# Cargamos $v0 un 0 por defecto por si no hay ningun error
	li $s5, 45		# Para comprobar si es negativo (el guion es 45 en ASII) y para comprobar_caracteres
	li $t1, 48		# Para comprobar_caracteres
	li $t2, 58		# Para comprobar_caracteres
	li $s1, 10		# Para multiplicar por 10 los valores decimales, y ademas para comprobar si un caracter es salto de linea
	li $s4, 10		# Como iterador que se va restando para comprobar que no sobrepase longitud de 10 caracteres (de 0 a 9, y con el salto de linea 10)
	
	lb $t7, 0($a0)		# Cargamos primer caracter
	beq $t7, $s5, negativo	# Si detecta guion pasamos a tratarlo como negativo
	j comprobar_caracteres	# Comprobamos caracteres no permitimos antes de pasar a la conversión
	convierte:
	beq $s7, $s5, bucle	# Comprueba si es negativo para que se salte restar al carácter guion 48 (la siguiente instrucción)
	subi $t7, $t7, 48	# Convertimos el caracter numerico a su decimal correspondiente (Este se ejecuta en caso de que sea positivo)
	bucle:
		addi $a0, $a0, 1		# Apuntamos al siguiente byte
		subi $s4, $s4, 1		# Restamos 1 al iterador de comprobación de longitud
		lb $t1, 0($a0)			# cargamos siguiente caracter
		beq $t1, $s1, exit		# Comprobamos si el siguiente caracter es salto de linea, en caso afirmativo salimos
		beq $t1, $zero, exit		# Comprobamos tambien si es caracter nulo
		beq $s4, $zero, error_longitud	# Si el iterador llega a 0 es que la cadena es demasiado larga y retorna error
		subi $t1, $t1, 48		# En caso contrario lo convertimos a su decimal
		mul $t7, $t7, $s1		# Lo multiplicamos por 10
		add $t7, $t7, $t1		# Sumamos el siguiente caracter al anterior que ha sido multiplicado por 10
		j bucle
		
	negativo:
		li $t7, 0		# Reseteamos el valor de $t7, para que '-' (guion) no lo sume con los siguientes caracteres
		li $s7, 45		# Valor arbitrario para indicar alguna comprobación de que es negativo
		addi $s4, $s4, 1	# Si es negativo el iterador debe ser 11 en vez de 10 para contar el guion
		addi $s3, $s3, 1	# Para que apunte al siguiente carácter después del guion
		j comprobar_caracteres	# Pasamos a comprobar los siguientes caracteres al guion
		
	comprobar_caracteres:
		lb $t0, 0($s3)				# Cargamos carácter	
		beq $t0, $s1, convierte			# Comprueba si ha llegado el salto de línea, para pasar a convertir a decimal
		blt $t0, $t1, error_caracter_incorrecto # Comprueba si está por debajo de 0 (48)
		blt $t0, $t2, siguiente_caracter	# Comprueba si es del 9 para abajo
		j error_caracter_incorrecto		# En caso de que sea carácter fuera del rango 0-9 (48-57) hay carácter incorrecto
		
	siguiente_caracter:	# Se utiliza para sumar +1 a la dirección y poder comprobar el siguiente caracter de la cadena
				# Mientras se comprueba si hay algún carácter no permitido
		addi $s3, $s3, 1
		j comprobar_caracteres
		
	exit:
		sb $zero, 0($a0)		# Sustituimos el salto de linea por caracter nulo
		beq $s7, $s5, exit_negativo	# Comprobamos antes de devolver el resultado si el numero es negativo
		add $v1, $t7, $zero		# En caso de ser positivo movemos el resultado de $t7 a $v0
		jr $ra				
		
	exit_negativo:
		sub $v1, $zero, $t7		# En caso de que sea negativo hacemos su opuesto y lo guardamos en $v0
		jr $ra
		
	error_longitud:
		li $v0, 1
		jr $ra
		
	error_caracter_incorrecto:
		li $v0, 2
		jr $ra
		
	
		
