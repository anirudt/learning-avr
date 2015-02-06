/*
 * DACADC.asm
 *
 *  Created: 30-01-2015 15:31:53
 *   Author: Anirud Thyagharajan
 */ 

 .INCLUDE "M32DEF.INC"
		LDI R16, 0xFF
		OUT DDRB, R16	; Signalling PortB as output
		OUT DDRD, R16	; Signalling PortD as output
		LDI R16, 0
		OUT DDRA, R16	; Signalling PortA as input
		LDI R16, 0x87	; 0x87 = 0b10000111, setting
		OUT ADCSRA, R16	; enable and clock f/128
		LDI R16, 0xC0	; 0xC0 = 0b11000000
						; 11 denotes 2.56V as reference
						; next 0 denotes rigth justified data
						; next 00000 shows ADC0 as input
		OUT ADMUX, R16
READ_ADC: 
		SBI ADCSRA, ADSC; starts conversion
KEEP_POLING: 
		SBIS ADCSRA, ADIF
		RJMP KEEP_POLING
		SBI ADCSRA, ADIF
		IN R16, ADCL
		OUT PORTD, R16	; Setting D as the lower byte
		IN R16, ADCH
		OUT PORTB, R16	; Setting B as the higher byte
		RJMP READ_ADC

