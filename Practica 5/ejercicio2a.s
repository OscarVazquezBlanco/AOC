.data

introduce: .asciiz "Introduzca numero decimal: "
decimal: .space 10

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall

la $a0, decimal
li $a1, 10
li $v0, 8
syscall

jal funcion

add $a0, $v0, $zero
li $v0, 1
syscall		# Imprime resultado

li $v0, 10
syscall		# Fin del programa

funcion:
	### PARAMETROS ###
	# $a0: número decimal codificado en ASCII

	### RETURN ###
	# $v0: retorna el parámetro convertido a binario
	
	li $s5, 45		# Para comprobar si es negativo (el guion es 45 en ASII)
	li $s1, 10		# Para multiplicar por 10 los valores decimales, y ademas para comprobar si un caracter es salto de linea
	lb $t7, 0($a0)		# Cargamos primer caracter
	beq $t7, $s5, negativo
	subi $t7, $t7, 48	# Convertimos el caracter numerico a su decimal correspondiente (Este se ejecuta en caso de que sea positivo)
	bucle:
		addi $a0, $a0, 1		# Apuntamos al siguiente byte
		lb $t1, 0($a0)			# cargamos siguiente caracter
		beq $t1, $s1, exit		# Comprobamos si el siguiente caracter es salto de linea, en caso afirmativo salimos
		beq $t1, $zero, exit		# Comprobamos tambien si es caracter nulo
		subi $t1, $t1, 48		# En caso contrario lo convertimos a su decimal
		mul $t7, $t7, $s1		# Lo multiplicamos por 10
		add $t7, $t7, $t1		# Sumamos el siguiente caracter al anterior que ha sido multiplicado por 10
		j bucle
		
	negativo:
		li $t7, 0	# Reseteamos el valor de $t7, para que '-' (guion) no lo sume con los siguientes caracteres
		li $s7, 45	# Valor arbitrario para indicar a la salida de la funcion que hay que devolver el opuesto
		j bucle		# Asi evitamos que reste 48 al caracter '-' (guion) que simplemente hay que ignorar
		
	exit:
		sb $zero, 0($a0)		# Sustituimos el salto de linea por caracter nulo
		beq $s7, $s5, exit_negativo	# Comprobamos antes de devolver el resultado si el numero es negativo
		add $v0, $t7, $zero		# En caso de ser positivo movemos el resultado de $t7 a $v0
		jr $ra				
		
	exit_negativo:
		sub $v0, $zero, $t7		# En caso de que sea negativo hacemos su opuesto y lo guardamos en $v0
		jr $ra
		
