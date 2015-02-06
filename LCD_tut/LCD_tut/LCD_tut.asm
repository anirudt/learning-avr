/*
 * LCD_interfacing.asm
 *
 *  Created: 23-01-2015 12:51:32
 
 */ 

 .INCLUDE "M32DEF.INC"
 .EQU LCD_DPRT = PORTA ; LCD DATA PORT
 .EQU LCD_DDDR = DDRA ;LCD DATA DDR
.EQU LCD_DPIN = PINA ;LCD DATA PIN
.EQU LCD_CPRT = PORTB ;LCD COMMANDS PORT
.EQU LCD_CDDR = DDRB ;LCD COMMANDS DDR
.EQU LCD_CPIN = PINB ;LCD COMMANDS PIN
.EQU LCD_RS = 0 ;LCD RS
.EQU LCD_RW = 1 ;LCD RW
.EQU LCD_EN = 2 ;LCD EN

LDI R21,HIGH(RAMEND)
OUT SPH,R21 ;set up stack
LDI R21,LOW(RAMEND)
OUT SPL,R21

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
LDI R16,0x06 ;shift cursor right
CALL CMNDWRT ;call command function
/*LDI R16, 'H' ;display letter 'H'
CALL DATAWRT ;call data write function
LDI R16, 'i' ;display letter 'i'
CALL DATAWRT ;call data write function
HERE: JMP HERE ;stay here*/
 LDI ZH, HIGH(DisplayTable<<1) ;R31 ;ZH high byte of addr.
		LDI ZL, LOW(DisplayTable<<1)  ;R30 ;ZL low byte of addr.
    L1: LPM R16,Z+
	    CPI R16,0
		BREQ HERE
        CALL DATAWRT
		RJMP L1
		HERE:	LDI R16,0xC0 ;clear LCD 
CALL CMNDWRT ;call command function 
CALL DELAY_2ms ;wait 2 ms 

LDI ZH, HIGH(DisplayTable2<<1) ;R31 ;ZH high byte of addr. 
LDI ZL, LOW(DisplayTable2<<1)  ;R30 ;ZL low byte of addr. 
    L2: LPM R16,Z+ 
    CPI R16,0 
BREQ HERE2 
        CALL DATAWRT 
RJMP L2 
HERE2: JMP HERE2

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

SDELAY: NOP
NOP
RET

DELAY_100us:
PUSH R17
LDI R17,60
DRO: CALL SDELAY
DEC R17
BRNE DRO
POP R17
RET

DELAY_2ms:
PUSH R17
LDI R17,20
LDRO: CALL DELAY_100us
DEC R17
BRNE LDRO
POP R17
RET

.ORG 0x500
	DisplayTable: .DB "RTES ",0
.ORG 0x400 
DisplayTable2: .DB "Embedded Lab",0
