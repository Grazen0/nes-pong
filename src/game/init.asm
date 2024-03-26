.include "init.inc"

.include "constants.inc"
.include "variables.inc"
.include "video/draw_buffer.inc"
.include "video/macros.inc"
.include "subroutines.inc"

.segment "CODE"

.proc GameInit
	;;; LOAD BACKGROUND NAMETABLE ($2000-$23FF)
	;;; Also sets all palette indices to 0
	LD_PPU_ADDR	$2000
	ldx	#$00
clear_bg_loop:
	sta	PPU_DATA
	sta	PPU_DATA
	sta	PPU_DATA
	sta	PPU_DATA
	inx
	bne	clear_bg_loop

	BUF_DRAW_RUN	($1FE0+($20*WALL_TILES)), TILE_COLUMNS, $04, DRAW_RIGHT
	BUF_DRAW_RUN	($23C0-($20*WALL_TILES)), TILE_COLUMNS, $05, DRAW_RIGHT
	
	MIDDLE_ADDR	= $200F + $20 * WALL_TILES
	LINE_LEN	= TILE_ROWS - 2 * WALL_TILES

	ldy	#$00
	lda	#>MIDDLE_ADDR
	sta	(buf_ptr), y
	iny
	lda	#<MIDDLE_ADDR
	sta	(buf_ptr), y
	iny

	lda	#($80 | (LINE_LEN - 1))
	sta	(buf_ptr), y
	iny

	ldx	#$00
load_middle_line_loop:
	lda	#$06
	sta	(buf_ptr), y
	iny
	lda	#$00
	sta	(buf_ptr), y
	iny

	inx
	cpx	#(LINE_LEN / 2)
	bne	load_middle_line_loop

	tya
	clc
	adc	buf_ptr	; Low byte
	sta	buf_ptr

	jsr	DrawBuffer

	;;; SPRITE INIT
	;;; Ball
	lda	#$01			; Tile index $01
	sta	spr_ball+SPR_TILE
	lda	#$00			; No mirroring, palette 0
	sta	spr_ball+SPR_ATTR

	;;; Paddle A
	ldx	#$00
load_paddle_a_loop:
	lda	paddle_a_data, x
	sta	sprs_paddle_a, x

	inx
	cpx	#(4*PADDLE_LEN)
	bne	load_paddle_a_loop

	;;; VARIABLE INIT
	jsr	ResetBall	; Ball

	;;; Paddles
	lda	#(SCREEN_MIDDLE_Y - (4 * PADDLE_LEN))
	sta	paddle_a_y
	sta	paddle_b_y

	rts
.endproc

;;; Goes to sprs_paddle_a
paddle_a_data:
	.byte $FF,$02,$00,PADDLE_A_X
	.repeat ::PADDLE_LEN - 2
		.byte $FF,$03,$00,PADDLE_A_X
	.endrep
	.byte $FF,$02,$80,PADDLE_A_X
	
paddle_b_data:
	.byte $FF,$02,$00,PADDLE_B_X
	.repeat ::PADDLE_LEN - 2
		.byte $FF,$03,$00,PADDLE_B_X
	.endrep
	.byte $FF,$02,$80,PADDLE_B_X
