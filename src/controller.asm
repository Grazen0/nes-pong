.include "controller.inc"

.include "system.inc"

.segment "ZEROPAGE"
buttons:	.res 1	; mask

.segment "CODE"

.proc ReadJoypad
	lda	#$01
	sta	JOYPAD_1
	sta	buttons
	lsr	a		; A = 0
	sta	JOYPAD_1
	
read_loop:
	lda	JOYPAD_1
	lsr	a
	rol	buttons
	bcc	read_loop

	rts
.endproc
