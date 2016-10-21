.data
introduce: .asciiz "Introduzca número decimal: "
Ox: .asciiz "0x"
decimal_ascii: .space 15
hex_ascii: .space 15
pila: .space 15

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall			# Imprimimos mensaje de introducir número por pantalla

la $a0, decimal_ascii
li $a1, 15
li $v0, 8
syscall			# Leemos número decimal como cadena de caracteres

jal funcionCADBIN	# Llamamos a función que convierte de cadena de caracteres a binario

add $a0, $v0, $zero	# Guardamos el número en binario en $a0 (será parámetro de la siguiente función)
li $v0, 0
la $a1, hex_ascii	# Cargamos dirección donde va a ir la cadena de caracteres que representa al número hexadecimal

jal funcionBINHEX

la $a0, Ox
li $v0, 4
syscall			# Imprimimos por pantalla 0x

la $a0, hex_ascii
li $v0, 4
syscall			# Imprimimos número hexadecimal en ASCII

li $v0, 10
syscall		# Fin del programa

funcionCADBIN:
	### PARAMETROS ###
	# $a0: número decimal codificado en ASCII

	### RETURN ###
	# $v0: retorna el parámetro convertido a binario
	
	li $s5, 45			# Para comprobar si es negativo (el guion es 45 en ASII)
	li $s1, 10			# Para multiplicar por 10 los valores decimales, y ademas para comprobar si un caracter es salto de linea
	lb $t7, 0($a0)			# Cargamos primer caracter
	beq $t7, $s5, negativoCADBIN	# Si es neegativo saltamos a la etiqueta para que lo trate como negativo
	subi $t7, $t7, 48		# Convertimos el caracter numerico a su decimal correspondiente (Este se ejecuta en caso de que sea positivo)
	bucleCADBIN:
		addi $a0, $a0, 1		# Apuntamos al siguiente byte
		lb $t1, 0($a0)			# cargamos siguiente caracter
		beq $t1, $s1, exitCADBIN	# Comprobamos si el siguiente caracter es salto de linea, en caso afirmativo salimos
		beq $t1, $zero, exitCADBIN	# Comprobamos tambien si es caracter nulo
		subi $t1, $t1, 48		# En caso contrario lo convertimos a su decimal
		mul $t7, $t7, $s1		# Lo multiplicamos por 10
		add $t7, $t7, $t1		# Sumamos el siguiente caracter al anterior que ha sido multiplicado por 10
		j bucleCADBIN
		
	negativoCADBIN:
		li $t7, 0	# Reseteamos el valor de $t7, para que '-' (guion) no lo sume con los siguientes caracteres
		li $s7, 45	# Valor arbitrario para indicar a la salida de la funcion que hay que devolver el opuesto
		j bucleCADBIN	# Asi evitamos que reste 48 al caracter '-' (guion) que simplemente hay que ignorar
		
	exitCADBIN:
		sb $zero, 0($a0)		# Sustituimos el salto de linea por caracter nulo
		beq $s7, $s5, exit_negativo	# Comprobamos antes de devolver el resultado si el numero es negativo
		add $v0, $t7, $zero		# En caso de ser positivo movemos el resultado de $t7 a $v0
		jr $ra				
		
	exit_negativo:
		sub $v0, $zero, $t7		# En caso de que sea negativo hacemos su opuesto y lo guardamos en $v0
		jr $ra


funcionBINHEX:
	### PARAMETROS ###
	# $a0: número en binario
	# $a1: dirección donde se guarda el número en hexadecimal
	add $t0, $a0, $zero
	add $s6, $zero, $zero 	# iterador inicial
	add $s7, $zero, 8 	# iterador final
	li $s0, 10	# Para comprobar si es número o letra
	bucleBINHEX:
		andi $t1, $t0, 0xF0000000
		srl $t1, $t1, 28
		blt $t1, $s0, numeros
		addi $t1, $t1, 55
		sb $t1, 0($a1)
		addi $a1, $a1, 1
		sll $t0, $t0, 4
		addi $s6, $s6, 1
		bne $s6, $s7, bucleBINHEX

		jr $ra
	
	numeros:
		addi $t1, $t1, 48
		sb $t1, 0($a1)
		addi $a1, $a1, 1
		sll $t0, $t0, 4
		addi $s6, $s6, 1
		bne $s6, $s7, bucleBINHEX
	
		jr $ra
