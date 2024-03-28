.include "bg_buffer.inc"

.include "system.inc"

.segment "ZEROPAGE"
bg_buf_ptr:		.res 2	; u16

.segment "CODE"

.proc UpdateBgBufPtr
	;;; bg_buf_ptr += Y + 1
	tya
	sec
	adc	bg_buf_ptr
	sta	bg_buf_ptr
	rts
.endproc

.proc ResetBgBufPtr
	lda	#<BG_BUF_ADDR
	sta	bg_buf_ptr
	lda	#>BG_BUF_ADDR
	sta	bg_buf_ptr+1
	rts
.endproc

.proc DrawBgBuffer
	lda	bg_buf_ptr
	bne	:+
	rts
:
	ldx	#$00
main_loop:
	;;; Load PPU_ADDR from next 2 bytes
	bit	PPU_STATUS
	lda	BG_BUF_ADDR+1, x	; High byte first...
	sta	PPU_ADDR
	lda	BG_BUF_ADDR, x		; ...then low byte
	sta	PPU_ADDR
	inx
	inx

	;;; Set VRAM increase direction
	lda	soft_ppu_ctrl

	ldy	BG_BUF_ADDR, x
	bmi	vram_down
vram_right:
	and	#%11111011
	jmp	:+
vram_down:
	ora	#%00000100
:	
	sta	PPU_CTRL

	;;; Check bit 6 for either literal or run
	lda	BG_BUF_ADDR, x
	rol			; Move bit 6 to sign...
	bmi	draw_run	; ...in order to check it

draw_literal:
	lda	BG_BUF_ADDR, x
	inx
	and	#%00111111

	tay	; Y holds the decreasing counter
	iny
literal_loop:
	lda	BG_BUF_ADDR, x
	sta	PPU_DATA
	inx
	dey
	bne	literal_loop

	jmp	main_loop_continue

draw_run:
	lda	BG_BUF_ADDR, x
	inx
	and	#%00111111
	clc
	adc	#$01
	tay

	lda	BG_BUF_ADDR, x
	inx
run_loop:
	sta	PPU_DATA
	dey
	bne	run_loop

main_loop_continue:
	cpx	bg_buf_ptr	; Assumes <draw_buf == $00
	bcc	main_loop

	jmp	ResetBgBufPtr
.endproc
