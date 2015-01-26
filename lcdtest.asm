.nolist
.include "m328Pdef.inc"
.list

.equ RS     = PORTB4
.equ Enable = PORTB3

.equ ControlPort = PORTB
.equ DataPort    = PORTD

.equ ControlPortMode = DDRB
.equ DataPortMode    = DDRD



	jmp main

main:
	ldi r16, LOW(RAMEND)	; stack setup
	out SPL, r16
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	
	ldi r16, 0xFF
	out ControlPortMode, r16
	out DataPortMode, r16
	
	ldi r16, 0x00
	out ControlPort, r16
	
	
	; wait one second for lcd to get ready
	rcall delay1sec
	
	; initialisation ritual
	ldi r16, 0b00110000
	out DataPort, r16
	rcall enable_pulse
	rcall delay5msec
	rcall enable_pulse
	rcall delay5msec
	rcall enable_pulse
	rcall delay5msec
	
	; set interface length to 4-bits
	ldi r16, 0b00100000
	out DataPort, r16
	rcall enable_pulse
		
	rcall delay5msec
	
	; from now on, communicate in bytes
	
	
	; Number of lines: 2, font: 5x8
	ldi r16, 0b00101000
	rcall send_command
	
	rcall delay5msec
	
	
	; Turn display on, blinking, cursor
	ldi r16, 0b00001100
	rcall send_command
	
	rcall delay5msec
	
	
	; Clear screen
	ldi r16, 0b00000001
	rcall send_command
	
	rcall delay5msec
	
	
	; Entry-mode settings
	ldi r16, 0b00000110
	rcall send_command
	
	rcall delay5msec


	ldi zh, HIGH(string*2)
	ldi zl, LOW(string*2)

loop:
	; Print a character
	push zh
	push zl
	
	lpm
	tst r0
	breq infloop
	mov r16, r0
	rcall send_data
	;rcall delay1sec
	
	pop zl
	pop zh

	adiw zl, 1

	rjmp loop
	
infloop: rjmp infloop
	
string:
	.db "  LCD Test! :D", 0x00
	
	
send_data:
	; RS to high
	in r18, ControlPort
	ori r18, (1 << RS)
	out ControlPort, r18

	out DataPort, r16
	rcall enable_pulse
	
	swap r16
	
	out DataPort, r16
	rcall enable_pulse
	
	ret		


send_command:
	; RS to low
	in r18, ControlPort
	andi r18, ~(1 << RS)
	out ControlPort, r18
	
	out DataPort, r16
	rcall enable_pulse
	
	swap r16
	
	out DataPort, r16
	rcall enable_pulse
	
	ret	
	

enable_pulse:
	; Enable to low
	in r18, ControlPort
	andi r18, ~(1 << Enable)
	out ControlPort, r18
	
	rcall delay1usec
	
	; Enable to high
	in r18, ControlPort
	ori r18, (1 << Enable)
	out ControlPort, r18
	
	rcall delay1usec
	
	; Enable to low
	in r18, ControlPort
	andi r18, ~(1 << Enable)
	out ControlPort, r18
	
	rcall delay100usec
	
	ret

	
	
delay5msec:		; 80 * 4 * 255 =~ 80000 cycles
	ldi zh, 80
    outerloop:
	ldi zl, 255
    innerloop:
	dec zl
	nop
	brne innerloop
    
	dec zh
	brne outerloop
	
	ret
	
	
	
delay100usec:		; 255 * 6 =~ 1600 cycles
	ldi r18, 255	
    loop100:
    	nop
    	nop
    	nop
	dec r18
	brne loop100
	
	ret
	

delay1usec:		; 4 * 4 = 16 cycles
	ldi r18, 4
    loop1:
	nop
	dec r18
	brne loop1
	
	ret
    
    
    
delay1sec:
	ldi r18,100
    outer1sec:
	ldi zh,HIGH(40000)
	ldi zl,LOW(40000)

    inner1sec:
	sbiw zl, 1
	brne inner1sec


	dec r18
	brne outer1sec
    
    
	ret
    
    
    
	
	
	

