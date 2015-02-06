/*
 * keyboard.asm
 *
 *  Created: 06-02-2015 15:52:39
 *   Author: Thyagu
 */ 


 .INCLUDE "M32DEF.INC"
.EQU KEY_PORT = PORTC
.EQU KEY_PIN = PINC
.EQU KEY_DDR = DDRC
.EQU LCD_DPRT = PORTA ; LCD DATA PORT
.EQU LCD_DDDR = DDRA ;LCD DATA DDR
.EQU LCD_DPIN = PINA ;LCD DATA PIN
.EQU LCD_CPRT = PORTB ;LCD COMMANDS PORT
.EQU LCD_CDDR = DDRB ;LCD COMMANDS DDR
.EQU LCD_CPIN = PINB ;LCD COMMANDS PIN
.EQU LCD_RS = 0 ;LCD RS
.EQU LCD_RW = 1 ;LCD RW
.EQU LCD_EN = 2 ;LCD EN

		LDI R20, HIGH(RAMEND)
		OUT SPH, R20
		LDI R20, LOW(RAMEND)
		OUT SPL, R20
		LDI R21, 0xFF
		OUT DDRD, R21
		LDI R20, 0xF0
		OUT KEY_DDR, R20


		LDI R21,0xFF;
		OUT LCD_DDDR, R21 ;LCD data port is output
		OUT LCD_CDDR, R21 ;LCD command port is output
		CBI LCD_CPRT,LCD_EN;LCD EN = 0
		CALL DELAY_2ms ;wait for power on
		LDI R16,0x38 ;init LCD 2 lines,5x7 matrix
		CALL CMNDWRT ;call command function
		CALL DELAY_2ms ;wait 2 ms
		LDI R16,0x0E ;display on, cursor on
		CALL CMNDWRT ;call command function
		LDI R16,0x01 ;clear LCD
		CALL CMNDWRT ;call command function
		CALL DELAY_2ms ;wait 2 ms


GROUND_ALL_ROWS: 	
		LDI R20, 0x0F
		OUT KEY_PORT, R20
WAIT_FOR_RELEASE:
		NOP
		IN R21, KEY_PIN
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BRNE WAIT_FOR_RELEASE
WAIT_FOR_KEY:
		NOP
		IN R21, KEY_PIN				 		
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BREQ WAIT_FOR_KEY
		CALL WAIT15MS
		IN R21, KEY_PIN
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BREQ WAIT_FOR_KEY
		LDI R21, 0b01111111
		OUT KEY_PORT, R21
		NOP
		IN R21, KEY_PIN
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BRNE COL1

		LDI R21, 0b10111111
		OUT KEY_PORT, R21
		NOP
		IN R21, KEY_PIN
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BRNE COL2

		LDI R21, 0b11011111
		OUT KEY_PORT, R21
		NOP
		IN R21, KEY_PIN
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BRNE COL3

		LDI R21, 0b11101111
		OUT KEY_PORT, R21
		NOP
		IN R21, KEY_PIN
		ANDI R21, 0x0F
		CPI R21, 0x0F
		BRNE COL4

COL1:
		LDI R30, LOW(KCODE0<<1)
		LDI R31, HIGH(KCODE0<<1)
		RJMP FIND	

COL2:
		LDI R30, LOW(KCODE1<<1)
		LDI R31, HIGH(KCODE1<<1)
		RJMP FIND

COL3:
		LDI R30, LOW(KCODE2<<1)
		LDI R31, HIGH(KCODE2<<1)
		RJMP FIND

COL4:
		LDI R30, LOW(KCODE3<<1)
		LDI R31, HIGH(KCODE3<<1)
		RJMP FIND	

FIND:
	LSR R21
	BRCC MATCH
	LPM R20, Z+
	RJMP FIND

MATCH:
	LPM R20, Z
	OUT PORTD, R20
	CALL DISPLAY_LCD
	RJMP GROUND_ALL_ROWS

WAIT15MS: LDI R16, 0x02
Delay:	LDI R17, 0xFF; 1 clock cycle
Loop1:	LDI R18, 0xFF; 1 clock cycle
Loop2:	DEC R18; 1 clock cycle
		BRNE Loop2; 2 clock cycles
		DEC R17; 1 clock cycle
		BRNE Loop1; 2 clock cycles
		DEC R16
		BRNE WAIT15MS
		; Totally, (1+3*255)*(5*255)*2 close to the square of the earlier delay.
		RET				

.ORG 0x300

KCODE0:  .DB '0', '1', '2', '3'
KCODE1:  .DB '4', '5', '6', '7'
KCODE2:	 .DB '8', '9', 'A', 'B'
KCODE3:  .DB 'C', 'D', 'E', 'F'	
;---------------------------------------------------------------------------------------

DISPLAY_LCD:	LDI R16,0x06 ;shift cursor right
				CALL CMNDWRT ;call command function
				LDI R16, 'H' ;display letter 'H'
				CALL DATAWRT ;call data write function		
				RET
				
CMNDWRT: 
				OUT LCD_DPRT,R16 ; LCD data port = R16 -
				CBI LCD_CPRT,LCD_RS ; RS 0 for command
				CBI LCD_CPRT,LCD_RW ;RW = 0 for write
				SBI LCD_CPRT,LCD_EN ;EN = 1
				CALL SDELAY ;make a wide EN pulse
				CBI LCD_CPRT,LCD_EN ;EN=O for H-to-L pulse
				CALL DELAY_100us ;wait 100 us
				RET

DATAWRT:
				OUT LCD_DPRT,R16 ;LCD data port = Rl6 -
				SBI LCD_CPRT,LCD_RS ;RS 1 for data
				CBI LCD_CPRT,LCD_RW ;RW = 0 for write
				SBI LCD_CPRT,LCD_EN ;EN = 1
				CALL SDELAY ;make a wide EN pulse
				CBI LCD_CPRT,LCD_EN ;EN=O for H-to-L pulse
				CALL DELAY_100us ;wait 100 us
				RET

SDELAY:			NOP
				NOP
				RET

DELAY_100us:
				PUSH R17
				LDI R17,60
DRO:			CALL SDELAY
				DEC R17
				BRNE DRO
				POP R17
				RET

DELAY_2ms:
				PUSH R17
				LDI R17,20
LDRO:			CALL DELAY_100us
				DEC R17
				BRNE LDRO
				POP R17
				RET												