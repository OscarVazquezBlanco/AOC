### Autores ###
# Alonso Astruga, Juan
# Vázquez Blanco, Óscar
.data
introduce: .asciiz "Introduzca numero hexadecimal: "
mensaje: .asciiz "Su numero en decimal es: "
num_hex: .space 55
num_dec: .space 20
pila: .space 15

.globl __start
.text
__start:

la $a0, introduce
li $v0, 4
syscall

la $a0, num_hex
li $a1, 50
li $v0, 8
syscall

jal funcionHEXBIN	# Convierte de hexadecimal a binario

add $a0, $v0, $zero	# Pasamos el resultado a $a0 para que la siguiente función lo tome como parámetro
la $a1, num_dec		# Cargamos dirección donde vamos a guardar el número decimal codificado en ASCII

jal funcionBINDEC	# Convierte de binario a decimal como cadena de caracteres

la $a0, mensaje
li $v0, 4
syscall			# Imprimimos mensaje aclaratorio

la $a0, num_dec
li $v0, 4
syscall			# Imprimimos el número decimal en ASCII

li $v0, 10
syscall		# Fin del programa

funcionHEXBIN: # Convierte de hexadecimal a binario (función de la práctica 4)
	### PARAMETROS ###
	# $a0: dirección con el número en hexadecimal codificado en ASCII
	
	### RETORNA ###
	# $v0: número hexadecimal introducido codificado en binario
	
	li $v0, 0		# Inicializamos a 0 donde vamos a guardar el resultado
	li $s0, 58		# $s0 vamos a utilizarla para distinguir si el caracter es numero o letra (del 48 al 57 son del 0 al 9)
	li $s1, 10		# Usamos $s1 para comprobar cuándo llega el salto de línea ('\n')
	add $t0, $a0, $zero	# $t0 variable con la que trabajamos, asi dejamos intacto $a0 por si se necesita
	bucle:
		lb $t1, 0($t0)
		beq $t1, $s1, exit_funcion	# Comprueba si es salto de línea
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
			
		exit_funcion:
			jr $ra
			
funcionBINDEC:	# Función correspondiente a la Práctica 6 (convierte de binario a decimal como cadena de caracteres)
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
			
			
