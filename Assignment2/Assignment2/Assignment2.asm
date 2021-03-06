/*
 * LCD1.asm
 *
 *  Created: 23-01-2015 05:53:57
 *   Author: Thyagu
 */ 

 .INCLUDE "M32DEF.INC"
 .EQU LCD_DPRT = PORTA
 .EQU LCD_DDDR = DDRA
 .EQU LCD_CPRT = PORTB
 .EQU LCD_CDDR = DDRB
 .EQU LCD_DPIN= PINA
 .EQU LCD_CPIN = PINB
 .EQU LCD_RS = 0
 .EQU LCD_RW = 1
 .EQU LCD_EN = 2

	LDI R21, HIGH(RAMEND)
	OUT SPH, R21
	LDI R21, LOW(RAMEND)
	OUT SPL, R21
	
		LDI R21, 0xFF
		OUT LCD_DDDR, R21
		OUT LCD_CDDR, R21
		CBI LCD_CPRT, LCD_EN ; Clearing a certain bit of the I/O reg. 
		CALL DELAY_2ms
		LDI R16, 0x38 ;  Init
		CALL CMNDWRT
		CALL DELAY_2ms
		LDI R16, 0x0E
		CALL CMNDWRT
		CALL DELAY_2ms
		LDI R16, 0x01
		CALL CMNDWRT
		CALL DELAY_2ms
		LDI R16, 0x06
		CALL CMNDWRT
		/*
L1:		LDI ZH, HIGH(MYDATA<<1)
		LDI ZL, LOW(MYDATA<<1)

L2:		LPM R16, Z+
		CPI R16, 0
		BREQ HERE
		CALL DATAWRT
		RJMP L2
		
		*/
		LDI R16, 'R'
		CALL DATAWRT
		LDI R16, 'T'
		CALL DATAWRT
		LDI R16, 'E'
		CALL DATAWRT
		LDI R16, 'S'
		CALL DATAWRT
		LDI R16, ' '
		CALL DATAWRT
		LDI R16, 'L'
		CALL DATAWRT
		LDI R16, 'A'
		CALL DATAWRT
		LDI R16, 'B'
		CALL DATAWRT
		
		LDI R16, 0xC0
		CALL CMNDWRT
		CALL DELAY_2ms
		LDI R16, 'E'
		CALL DATAWRT
		LDI R16, 'E'
		CALL DATAWRT
HERE:	JMP HERE


CMNDWRT:	OUT LCD_DPRT, R16
			CBI LCD_CPRT, LCD_RS
			CBI LCD_CPRT, LCD_RW
			SBI LCD_CPRT, LCD_EN
			CALL SDELAY
			CBI LCD_CPRT, LCD_EN
			CALL DELAY_100us
			RET

DATAWRT:	OUT LCD_DPRT, R16
			SBI LCD_CPRT, LCD_RS
			CBI LCD_CPRT, LCD_RW
			SBI LCD_CPRT, LCD_EN
			CALL SDELAY
			CBI LCD_CPRT, LCD_EN
			CALL DELAY_100us
			RET
		
SDELAY:	NOP
		NOP
		RET
		
DELAY_100us:	PUSH R17
				LDI R17, 60				 
DR0:			CALL SDELAY
				DEC R17
				BRNE DR0
				POP R17
				RET

DELAY_2ms:		PUSH R17
				LDI R17, 20
LDR0:			CALL SDELAY
				DEC R17
				BRNE LDR0
				POP R17
				RET
/*
.ORG 0x500
MYDATA:			.DB "Anirud", 0			
*/
