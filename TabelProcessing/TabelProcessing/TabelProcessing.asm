/*
 * TabelProcessing.asm
 *
 *  Created: 22-01-2015 14:21:26
 *   Author: Thyagu
 */ 

		.INCLUDE "M32DEF.INC"
		.ORG 0x0000

		LDI R16, 0xFF
		OUT DDRB, R16
; Data is stored here in 2 bytes hence the shifting is done.
		LDI ZH, HIGH(MYDATA<<1) ; Loading address of our data
		LDI ZL, LOW(MYDATA<<1) ; Here too!

LOOP1:	LPM R20, Z+ ; Similar to post increment, after loading
		CPI R20, 0 ; Null termination or not 
		BREQ END
		OUT PORTB, R20 
		RJMP LOOP1

		
END:	RJMP END
		.ORG 0x500
MYDATA: .DB "HELLO WORLD", 0