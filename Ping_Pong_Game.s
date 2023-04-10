#include <xc.inc>

; ZONA DE CONFIGURACION GENERAL
    CONFIG FOSC = XT
    CONFIG WDTE = OFF
    CONFIG PWRTE = OFF
    CONFIG CP = OFF

; DEFINICION DE LA SECCION DEL CODIGO
    PSECT Programa, class=CODE,delta=2,abs
    ORG 00h
    M1 EQU 0Ch
    M2 EQU 0Dh
    tiempo EQU 0Eh
    saqueP1 EQU 0Fh
    saqueP2 EQU 10H
    cont3 EQU 11h
    cont2 EQU 12h
    cont1 EQU 13h

    Programa:
	GOTO INICIO

; ZONA DE CONFIGURACION DE LOS PUERTOS
	INICIO:
;CONFIGURAMOS TODO EL PUERTO B COMO SALIDA
	    bsf STATUS,5
	    clrf TRISB
;CONFIGURAMOS EL PUERTO A COMO ENTRADA
	    MOVLW 11111001B
	    MOVWF TRISA
	    bcf STATUS,5

	    principal:	
		movlw 11111111B
		movwf PORTB			
		btfss PORTA,3
		goto principal
		goto Secuencia_inicio
	    
            
	    Secuencia_inicio:
		clrf PORTB
	;Primer encendido
		movlw 00011000B
		movwf PORTB		
		movlw 00000010B
		movwf PORTA		
		call sec_inicio
		clrf PORTA
		call sec_inicio
		
	;Segundo encendido
		movlw 00111100B
		movwf PORTB
		movlw 00000010B
		movwf PORTA
		call sec_inicio
		clrf PORTA
		call sec_inicio
		
	;Tercer encendido
		movlw 01111110B
		movwf PORTB
		movlw 00000010B
		movwf PORTA
		call sec_inicio
		call sec_inicio
		clrf PORTA
		call sec_inicio
		
	;Cuarto encendido
		movlw 11111111B
		movwf PORTB
		movlw 00000010B
		movwf PORTA
		call sec_inicio
		call sec_inicio
		call sec_inicio
		clrf PORTA
		
		
	    startGame:
		clrf PORTB
		clrf M1
		clrf M2
		movlw 00000011B
		movwf saqueP1
		movwf saqueP2

		turnoP1:
		    BTFSS saqueP1,1
		    goto turnoValP1
		    goto turnoP1_1
		    turnoP1_1:   
			decf saqueP1,1
			;BTFSC saqueP1,0
			goto saqueJ1
			;goto turnoP2
		    turnoValP1:
			BTFSC saqueP1,0
			goto turnoP1_1
			goto turnoP2

		turnoP2:
		    BTFSS saqueP2,1
		    goto turnoValP2
		    goto turnoP2_1
		    turnoP2_1:  
			decf saqueP2,1
			goto saqueJ2
			;goto endGame
		    turnoValP2:
			BTFSC saqueP2,0
			goto turnoP2_1
			goto endGame
	    saqueJ1:		
		movlw 00000001B
		movwf PORTB
		btfss PORTA,0
		goto saqueJ1
		goto Sonido1

	    saqueJ2:
		movlw 10000000B
		movwf PORTB
		btfss PORTA,4
		goto saqueJ2
		goto Sonido2

	    Sonido1:
		movlw 00000010B
		movwf PORTA
		call sec_inicio
		clrf PORTA
		goto derechaIzq
	    
	    Sonido2:
		movlw 00000010B
		movwf PORTA
		call sec_inicio
		clrf PORTA
		goto izquierdaDer
	    
	    derechaIzq:
		call sec_tiempo
		rlf PORTB,1
		btfss PORTB,7
		goto derechaIzq
		goto marcadorP1

	 
	    izquierdaDer:
		call sec_tiempo
		rrf PORTB,1
		btfss PORTB,0
		goto izquierdaDer
		goto marcadorP2

	    marcadorP1:
		call sec_tiempo
		BTFSC PORTA,4
		goto Sonido2
		goto resultadoP1

            resultadoP1:
		incf M1,1
		goto turnoP1

	    marcadorP2:
		call sec_tiempo
		BTFSC PORTA,0
		goto Sonido1
		goto resultadoP2

	    resultadoP2:
		incf M2,1
		goto turnoP1

	    endGame:
		movf M1,0
		subwf M2,0
		btfsc STATUS,2
		goto p1_eq_p2
		btfss STATUS,0
		goto Mp2mp1
		goto mp2Mp1
	    p1_eq_p2:
		movlw 00111100B
		movwf PORTB
		goto restartGame
	    Mp2mp1:
		movlw 00001111B
		movwf PORTB
		goto restartGame
	    mp2Mp1:
		movlw 11110000B
		movwf PORTB
		goto restartGame

	    sec_tiempo:
		Part3:
		    movlw 1
		    movwf cont3
		vuelta3:
		    movlw 150
		    movwf cont2
		vuelta2:
		    movlw 255
		    movwf cont1
		vuelta1:
		    decfsz cont1,1
		    goto vuelta1

		    decfsz cont2,1
		    goto vuelta2

		    decfsz cont3,1
		    goto vuelta3
	    return
	    
	    sec_inicio:
		P3:
		    movlw 2
		    movwf cont3
		v3:
		    movlw 150
		    movwf cont2
		v2:
		    movlw 255
		    movwf cont1
		v1:
		    decfsz cont1,1
		    goto v1

		    decfsz cont2,1
		    goto v2

		    decfsz cont3,1
		    goto v3
	    return

	    restartGame:
		clrf PORTA
		btfss PORTA,3
		goto restartGame
		goto startGame

	    gameOver:
		END Programa