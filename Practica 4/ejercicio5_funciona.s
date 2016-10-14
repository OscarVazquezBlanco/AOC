.data
	dato: .space 12 #para que tenga un poco más de espacio
	cadena: .asciiz"Introduzca número en hexadecimal\n"
	hex:.asciiz"0X"
	espacio:.asciiz"\n"
	cadena_larga:.asciiz "Cadena demasiado larga\n"
	caracteres_extraños:.asciiz "Cadena contiene caracteres no permitidos\n"
	resultado:.space 10
.globl __start
.text
__start:

la $a0,cadena
li $v0,4
syscall

la $a0,hex
li $v0,4
syscall

la $a0,dato
addi $a1,$a1,10 #permitimos ahora cadenas más largas
li $v0,8
syscall

jal funcion1

addi $t1,$zero,1 #comparador codigo de error cadena demaisado larga
addi $t2,$zero,2 #comparador codigo de error cadena conrtiene caracteres extraños

add $s1,$v1,$zero #ponemos temporalmete el valor obtenido cuando la cadena es correcta en s1
add $s0,$v0,$zero #ponemos temporalmete el codigo de error en s0

la $a0,espacio
li $v0,4
syscall

add $v0,$s0,$zero 

beq $t1,$v0,cadena_demasiado_larga
beq $t2,$v0,caracteres_raros

add $a0,$s1,$zero #El resultado queda en el $a0

la $a1,resultado

jal funcion2

la $a0,resultado

li $v0,4
syscall
tratados_los_errores:
li $v0,10
syscall

	
cadena_demasiado_larga:
	la $a0,cadena_larga #imprime el mensaje de que la cadena introducida por teclado es demasiado larga
	li $v0,4
	syscall
	b tratados_los_errores
				
caracteres_raros:
	la $a0,caracteres_extraños #imprime el mensaje de que la cadena introducida por teclado contiene 
	li $v0,4		   #caracteres no permitidos
	syscall
	b tratados_los_errores
cad_lag:
				addi $v0,$zero,1
				b sal
car_rar:
				addi $v0,$zero,2
				b sal
funcion1:
		add $t9,$a0,$zero #dirección con la que trabajamos
		addi $t7,$zero,10 #constante a comparar para el salto de linea
		add $t0,$zero,$zero # contador longitud de la cadena
		add $t3,$zero,$zero
		
		quitar_salto_de_linea:
			
			lb $t3,0($t9)
			addi $t9,$t9,1 #incrementa la dirección en una unidad hasta que conseguimos encontrar el caracter\n
			addi $t0,$t0,1
			
			beq $t0,$t7,cad_lag #aprovechamos que el registro $t7 contiene 10 para compararlo con la longitud de la cadena
					    #si la cdaena tiene esa longitud significa que es más larga de la cuenta					    		    
			bne $t3,$t7,quitar_salto_de_linea #comparamos el valor leido de memoria con 10 (caracter \n)
			addi $t9,$t9,-1
			add $t3,$zero,$zero #con estas dos sentencias conseguimos quitar el caracter salto de linea que se introduce 
			sb $t3,0($t9)    #automaticamente al dar un valor por teclado				
			
		caracteres_permitidos:
			add $t9,$a0,$zero #dirección con la que trabajamos
			addi $t1,$zero,48 #constante 48 para saber si el caracter no está permitido
			addi $t2,$zero,58 #constante 57 para saber si el caracter no está permitido
			
			addi $t4,$zero,65 #constante 65 para saber si el caracter no está permitido
			addi $t5,$zero,91 #constante 90 para saber si el caracter no está permitido
			add $t7,$zero,$zero
			
			bucle_caracter:
			lb $t3,0($t9)
		
			beq $t3,$zero,caracter_permitido #si el caracter es el 0 es el terminador de cadena y por tanto podemos pasar a la funcion
		
			slt $t7,$t3,$t1 	#Es el caracter menor que 48?
			bne $t7,$zero,car_rar   #en caso afirmativo sal de la funcion y devuelve el codigo de error 2
			
			slt $t7,$t3,$t2 	#Es el caracter menor que 58?
			
			bne $t7,$zero,caracter_permitido  #en caso de que 48<=caracter<58 es un caracter permitido y entonces pasa al siguiente caracter				
			
			slt $t7,$t3,$t4  	#Es el caracter menor que 65?
			
			bne $t7,$zero,car_rar   #en caso de que 57<caracter<65 es un caracter prohibido y entonces sale de la funcion, si no no
				
			slt $t7,$t3,$t5 	#Es el caracter menor que 91?
			
			beq $t7,$zero,car_rar   #en caso de que no lo sea (65<nºcaracter<91) sal de la funcion porque es un caracter bo valido
			
			caracter_permitido:
			addi $t9,$t9,1	
			
			bne $t3,$zero,bucle_caracter
			
			#Una vez que nos hemos asegurado que la cadena no contiene nada erroneo comenzamos con la función
			
			add $t9,$a0,$zero #dirección con la que trabajamos
			addi $t8,$zero,64   #constante con la que compararemos para ver si el caracter es un numero o una letra	
			
		bucle:
			add $t3,$zero,$zero
			
			lb $t2,0($t9)
			beq $t2,$zero,sal #Si el valor es igual a cero hemos encontrado el terminador de cadena
			sll $v1,$v1,4
			blt $t2,$t8,menor
			
			addi $t3,$t2,-55 #Si el número no es menor que 64 es que es una letra mayúscula
			
			continua:
			
			or $v1,$t3,$v1
						
			addi $t9,$t9,1
						
			bne $t2,$zero,bucle
		sal:
			jr $ra

		menor:
		
			addi $t3,$t2,-48 #Si es menor que 64 es que es un número y se le tiene que restar 48
			b continua
			
		
funcion2:

	add $t8,$a0,$zero #dato con el que trabajar
	
	addi $t7,$zero,10 #constante 10
	addi $t3,$zero,8 #indice del contador
	addi $t0,$zero,1 #constante 1
	buclef2:
		add $t5,$a1,$t3
		andi $t1,$t8,0xf0000000
		nor $t1,$t1,$zero #nor con cero cambia ceros por unos y unos por ceros		
		srl $t1,$t1,28
		beq $t3,$t0,suma_1
		c2:	
		sll $t8,$t8,4
		blt $t1,$t7,menor2	
		addi $t1,$t1,55
		c1:
		sb $t1,0($a1)
		addi $a1,$a1,1
		addi $t3,$t3,-1
		bne $t3,$zero,buclef2
	jr $ra
	menor2:
		addi $t1,$t1,48
		b c1
	suma_1:
		addi $t1,$t1,1
		b c2
