.data
introduce: .asciiz "Introduzca número decimal: "
decimal_ascii_1: .space 15
decimal_ascii_2: .space 15
pila: .space 15

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall			# Imprimimos mensaje de introducir número por pantalla

la $a0, decimal_ascii_1
li $a1, 15
li $v0, 8
syscall			# Leemos número decimal como cadena de caracteres

jal funcionCADBIN	# Llamamos a función que convierte de cadena de caracteres a binario

sll $a0, $v0, 1		# El número en binario lo multiplicamos por 2 añadiendo un cero por la derecha, y lo guardamos en $a0
la $a1, decimal_ascii_2	# Cargamos dirección donde va a ir la cadena de caracteres que representa al número decimal

jal funcionBINCAD

la $a0, decimal_ascii_2
li $v0, 4
syscall

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
	bucle:
		addi $a0, $a0, 1		# Apuntamos al siguiente byte
		lb $t1, 0($a0)			# cargamos siguiente caracter
		beq $t1, $s1, exitCADBIN	# Comprobamos si el siguiente caracter es salto de linea, en caso afirmativo salimos
		beq $t1, $zero, exitCADBIN	# Comprobamos tambien si es caracter nulo
		subi $t1, $t1, 48		# En caso contrario lo convertimos a su decimal
		mul $t7, $t7, $s1		# Lo multiplicamos por 10
		add $t7, $t7, $t1		# Sumamos el siguiente caracter al anterior que ha sido multiplicado por 10
		j bucle
		
	negativoCADBIN:
		li $t7, 0	# Reseteamos el valor de $t7, para que '-' (guion) no lo sume con los siguientes caracteres
		li $s7, 45	# Valor arbitrario para indicar a la salida de la funcion que hay que devolver el opuesto
		j bucle		# Asi evitamos que reste 48 al caracter '-' (guion) que simplemente hay que ignorar
		
	exitCADBIN:
		sb $zero, 0($a0)		# Sustituimos el salto de linea por caracter nulo
		beq $s7, $s5, exit_negativo	# Comprobamos antes de devolver el resultado si el numero es negativo
		add $v0, $t7, $zero		# En caso de ser positivo movemos el resultado de $t7 a $v0
		jr $ra				
		
	exit_negativo:
		sub $v0, $zero, $t7		# En caso de que sea negativo hacemos su opuesto y lo guardamos en $v0
		jr $ra


funcionBINCAD:
	### PARAMETROS ###
	# $a0: numero binario
	# $a1: direccion donde se guardara el binario como decimal codificado en ASCII
	
	li $s0, 10				# Para dividir entre 10
	la $s7, pila				# Cargamos dirección inicial de la pila
	add $s6, $s7, $zero			# Guardamos dirección inicial de la pila para recordarla al sacar de la pila
	blt $a0, $zero, negativoBINCAD		# Comprobamos si el número binario a convertir es negativo 
	
	cambio_de_base:
		div $a0, $s0				# Dividos entre 10
		mfhi $t0				# Movemos el resto a $t0
		sb $t0, 0($s7)				# Guardamos en la pila el resto de la división
		mflo $t1				# Movemos el cociente a $t1
		beq $t1, $zero, convertir_a_ascii	# Si el cociente es 0, pasamos a convertir a ASCII lo guardado en la pila
		add $a0, $t1, $zero			# Guardamos el cociente en $a0 para seguir dividiendolo entre 10
		addi $s7, $s7, 1			# Aumentamos en 1 la direccion que apunta a la pila
		j cambio_de_base
		
	negativoBINCAD:
		li $t0, 45		# Guardamos temporalmente carácter guion (para signo negativo) en $t0
		sb $t0, 0($a1)		# Guardamos el guion en primer elemento de la cadena de caracteres
		addi $a1, $a1, 1	# Aumentamos dirección en 1 a donde guardanos la cadena
		sub $a0, $zero, $a0	# Hacemo el complemento a 2 del número binario
		j cambio_de_base	# Saltamos para hacer el cambio de base a decimal
		
	convertir_a_ascii:
		lb $t0, 0($s7)		# Cargamos elemento de la pila
		addi $t1, $t0, 48	# Convertimos el decimal a su correspondiente codificación ASCII
		sb $t1, 0($a1)		# Guardamos en memoria el carácter
		beq $s7, $s6, exitBINCAD# Comprobamos si la dirección de la pila es igual a su dirección inicial, para ver si hemos acabado
		subi $s7, $s7, 1	# Restamos en 1 la dirección donde apunta a la pila para mirar el siguiente byte
		addi $a1, $a1, 1	# Aumentamos en 1 la direccion donde estamos guardando los caracteres
		j convertir_a_ascii
		
	exitBINCAD:
		jr $ra