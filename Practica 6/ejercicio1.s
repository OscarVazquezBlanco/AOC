funcion:
	### PARAMETROS ###
	# $a0: numero binario
	# $a1: direccion donde se guardara el binario como decimal codificado en ASCII
	
	li $s0, 10				# Para dividir entre 10
	la $s7, pila				# Cargamos dirección inicial de la pila
	add $s6, $s7, $zero			# Guardamos dirección inicial de la pila para recordarla al sacar de la pila
	blt $a0, $zero, negativo		# Comprobamos si el número binario a convertir es negativo 
	
	cambio_de_base:
		div $a0, $s0				# Dividos entre 10
		mfhi $t0				# Movemos el resto a $t0
		sb $t0, 0($s7)				# Guardamos en la pila el resto de la división
		mflo $t1				# Movemos el cociente a $t1
		beq $t1, $zero, convertir_a_ascii	# Si el cociente es 0, pasamos a convertir a ASCII lo guardado en la pila
		add $a0, $t1, $zero			# Guardamos el cociente en $a0 para seguir dividiendolo entre 10
		addi $s7, $s7, 1			# Aumentamos en 1 la direccion que apunta a la pila
		j cambio_de_base
		
	negativo:
		li $t0, 45		# Guardamos temporalmente carácter guion (para signo negativo) en $t0
		sb $t0, 0($a1)		# Guardamos el guion en primer elemento de la cadena de caracteres
		addi $a1, $a1, 1	# Aumentamos dirección en 1 a donde guardanos la cadena
		sub $a0, $zero, $a0	# Hacemo el complemento a 2 del número binario
		j cambio_de_base	# Saltamos para hacer el cambio de base a decimal
		
	convertir_a_ascii:
		lb $t0, 0($s7)		# Cargamos elemento de la pila
		addi $t1, $t0, 48	# Convertimos el decimal a su correspondiente codificación ASCII
		sb $t1, 0($a1)		# Guardamos en memoria el carácter
		beq $s7, $s6, exit	# Comprobamos si la dirección de la pila es igual a su dirección inicial, para ver si hemos acabado
		subi $s7, $s7, 1	# Restamos en 1 la dirección donde apunta a la pila para mirar el siguiente byte
		addi $a1, $a1, 1	# Aumentamos en 1 la direccion donde estamos guardando los caracteres
		j convertir_a_ascii
		
	exit:
		jr $ra