.include "init.inc"

.include "pseudo_ops.inc"
.include "constants.inc"
.include "variables.inc"
.include "bg_buffer.inc"
.include "subroutines.inc"

.segment "CODE"

.proc GameInit
	;;; Clear background and set all palette indices to 0
	LD_PPU_ADDR	$2000
	ldx	#$00
clear_bg_loop:
	sta	PPU_DATA
	sta	PPU_DATA
	sta	PPU_DATA
	sta	PPU_DATA
	inx
	bne	clear_bg_loop

.proc varInit
	;;; Scores
	; ldx	#$00
	stx	player_a_score
	stx	player_b_score

	;;; Paddles
	lda	#(SCREEN_MIDDLE_Y - (PADDLE_HEIGHT / 2))
	sta	paddle_a_y
	sta	paddle_b_y

	jsr	ResetBall	; Ball
.endproc

.proc backgroundInit
	;;; BACKGROUND STUFF
	ldy	#$00
	BG_BUF_ENTRY_SETUP ($1FE0+($20*WALL_TILES)), TILE_COLUMNS, (DRAW_RIGHT | DRAW_RUN)
	lda	#$04
	sta	(bg_buf_ptr), y
	iny
	BG_BUF_ENTRY_SETUP ($23C0-($20*WALL_TILES)), TILE_COLUMNS, (DRAW_RIGHT | DRAW_RUN)
	lda	#$05
	sta	(bg_buf_ptr), y

	jsr	UpdateBgBufPtr

	jsr	DrawPlayerAScore
	jsr	DrawPlayerBScore

	jsr	DrawBgBuffer
	
	;;; DRAW MIDDLE LINE
	lda	soft_ppu_ctrl
	ora	#%00000100	; Draw downwards
	sta	PPU_CTRL
	LD_PPU_ADDR ($200F + $20 * WALL_TILES)

	ldx	#((TILE_ROWS / 2) - WALL_TILES)	; Decreasing counter
	lda	#$06
middle_line_left_loop:
	sta	PPU_DATA
	bit	PPU_DATA	; Skip every other tile
	dex
	bne	middle_line_left_loop
	
	LD_PPU_ADDR ($2010 + $20 * WALL_TILES)

	ldx	#((TILE_ROWS / 2) - WALL_TILES)	; Decreasing counter
	lda	#$16
middle_line_right_loop:
	sta	PPU_DATA
	bit	PPU_DATA	; Skip every other tile
	dex
	bne	middle_line_right_loop
.endproc

.proc spriteInit
	;;; Ball
	lda	#$01			; Tile index $01
	sta	spr_ball+Sprite::TILE
	lda	#$00			; No mirroring, palette 0
	sta	spr_ball+Sprite::ATTR

	;;; Paddles
	ldx	#(4 * PADDLE_TILES)	; Decreasing counter
load_paddles_loop:
	lda	paddle_a_data, x
	sta	sprs_paddle_a, x
	lda	paddle_b_data, x
	sta	sprs_paddle_b, x
	dex
	bne	load_paddles_loop
.endproc

	rts
.endproc

;;; Goes to sprs_paddle_a
paddle_a_data:
	.byte $FF,$02,$00,PADDLE_A_X
	.repeat PADDLE_TILES - 2
		.byte $FF,$03,$00,PADDLE_A_X
	.endrep
	.byte $FF,$02,$80,PADDLE_A_X
	
paddle_b_data:
	.byte $FF,$02,$00,PADDLE_B_X
	.repeat PADDLE_TILES - 2
		.byte $FF,$03,$00,PADDLE_B_X
	.endrep
	.byte $FF,$02,$80,PADDLE_B_X
