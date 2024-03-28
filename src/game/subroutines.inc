.ifndef __GAME_SUBROUTINES_INC__
__GAME_SUBROUTINES_INC__ = 1

.include "bg_buffer.inc"

.global ResetBall
.global DrawPlayerAScore
.global DrawPlayerBScore

.macro DRAW_X_BIG_NUMBER ppu_addr
	BG_BUF_ENTRY_SETUP ppu_addr, $03, (DRAW_LIT | DRAW_DOWN)
	lda	digit_tile_1_1, x
	sta	(bg_buf_ptr), y
	iny
	lda	digit_tile_2_1, x
	sta	(bg_buf_ptr), y
	iny
	lda	digit_tile_3_1, x
	sta	(bg_buf_ptr), y
	iny
	
	BG_BUF_ENTRY_SETUP (ppu_addr+1), $03, (DRAW_LIT | DRAW_DOWN)
	lda	digit_tile_1_2, x
	sta	(bg_buf_ptr), y
	iny
	lda	digit_tile_2_2, x
	sta	(bg_buf_ptr), y
	iny
	lda	digit_tile_3_2, x
	sta	(bg_buf_ptr), y
.endmacro

.endif
