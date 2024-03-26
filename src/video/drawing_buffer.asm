.include "draw_buffer.inc"

.include "system.inc"

.segment "ZEROPAGE"
buf_ptr:		.res 2	; u16

.segment "BSS"
DRAW_BUF_ADDR:	.res $0100

.segment "CODE"

.proc ResetBufPtr
	lda	#<DRAW_BUF_ADDR
	sta	buf_ptr
	lda	#>DRAW_BUF_ADDR
	sta	buf_ptr+1
	rts
.endproc

.proc DrawBuffer
	lda	buf_ptr
	bne	:+
	rts
:
	ldx	#$00
main_loop:
	;;; Load PPU_ADDR from next 2 bytes
	bit	PPU_STATUS
	lda	DRAW_BUF_ADDR, x
	sta	PPU_ADDR
	inx
	lda	DRAW_BUF_ADDR, x
	sta	PPU_ADDR
	inx

	;;; Set VRAM increase direction
	lda	DRAW_BUF_ADDR, x
	bmi	vram_down
vram_up:
	lda	#%10000000
	jmp	:+
vram_down:
	lda	#%10000100
:	
	sta	PPU_CTRL

	;;; Check bit 6 for either literal or run
	lda	DRAW_BUF_ADDR, x
	rol			; Move bit 6 to sign...
	bmi	draw_run	; ...in order to check it

draw_literal:
	lda	DRAW_BUF_ADDR, x
	inx
	and	#%00111111
	
	;;; Y = A + 1 = data_len
	tay
	iny
@loop:
	lda	DRAW_BUF_ADDR, x
	sta	PPU_DATA
	inx
	dey
	bne	@loop

	jmp	main_loop_continue

draw_run:
	lda	DRAW_BUF_ADDR, x
	inx
	and	#%00111111
	clc
	adc	#$01
	tay

	lda	DRAW_BUF_ADDR, x
	inx
@loop:
	sta	PPU_DATA
	dey
	bne	@loop

main_loop_continue:
	cpx	buf_ptr	; Assumes <draw_buf == $00
	bcc	main_loop

	jsr	ResetBufPtr

	rts
.endproc
