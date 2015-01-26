/*
 * Tutorial1.asm
 *
 *  Created: 16-01-2015 14:16:35
 *   Author: Thyagu
 * LED Blinking
 */ 
.INCLUDE "M32DEF.INC"
.ORG 0

LDI R16, HIGH(RAMEND)
OUT SPH, R16
LDI R16, LOW(RAMEND)
OUT SPL, R16

; LED is going to be connected to A, so put it as output [pull up resistor activation]
LDI R16, 0xFF
OUT DDRA, R16

MAIN:	OUT PORTA, R16
		CALL Delay
		COM R16 ;complementing the register, to enable toggling
		RJMP MAIN

Delay:	LDI R17, 0xFF; 1 clock cycle
Loop1:	LDI R18, 0xFF; 1 clock cycle
Loop2:	DEC R18; 1 clock cycle
		BRNE Loop2; 2 clock cycles
		DEC R17; 1 clock cycle
		BRNE Loop1; 2 clock cycles
		; Totally, (1+3*255)*(5*255)+1 close to the square of the earlier delay.
		RET