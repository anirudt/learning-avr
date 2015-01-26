/*
 * PortBToggle.asm
 *
 *  Created: 11-01-2015 21:38:26
 *   Author: Thyagu
 */ 
 // For LDI instructions, we have to use registers b/w R16-R31, as
 // R0-R15 are not available for LDI instructions.

		 .INCLUDE "M32DEF.INC"
		 .ORG 0

		 LDI R16, HIGH(RAMEND)
		 OUT SPH, R16
		 LDI R16, LOW(RAMEND)
		 OUT SPL, R16

		 LDI R16, 0xFF
		 OUT DDRB, R16 //Data Directional Register

MAIN:
		LDI R16, 0x00
		OUT PORTB, R16
		CALL Delay
		LDI R16,0xFF
		OUT PORTB, R16
		CALL Delay
		RJMP MAIN

Delay:
		LDI R16, 0Xff
		
AGAIN:	NOP
		NOP
		NOP
		DEC R16
		BRNE AGAIN
		RET 





