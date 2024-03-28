.include "subroutines.inc"

.include "system.inc"
.include "random.inc"
.include "constants.inc"
.include "variables.inc"
.include "bg_buffer.inc"

.segment "CODE"
	
.proc ResetBall
	lda	#(SCREEN_MIDDLE_X - (BALL_SIZE / 2))
	sta	ball_x
	lda	#(SCREEN_MIDDLE_Y - (BALL_SIZE / 2))
	sta	ball_y

	lda	#BALL_SP_X_INIT
	sta	ball_speed_x

	jsr	RandomByte
	bpl	neg	; 50/50 chance

	lda	#$01	; ball_speed_y = +1
	jmp	:+

neg:	lda	#$FF	; ball_speed_y = -1

:	sta	ball_speed_y
	rts

.endproc

.proc DrawPlayerAScore
	ldy	player_a_score
	ldx	left_digit_table, y
	ldy	#$00

	DRAW_X_BIG_NUMBER $20B2
	iny

	ldx	player_a_score
	lda	right_digit_table, x
	tax
	DRAW_X_BIG_NUMBER $20B5

	jmp	UpdateBgBufPtr
.endproc

.proc DrawPlayerBScore
	ldy	player_b_score
	ldx	left_digit_table, y
	ldy	#$00

	DRAW_X_BIG_NUMBER $20A9
	iny

	ldx	player_b_score
	lda	right_digit_table, x
	tax
	DRAW_X_BIG_NUMBER $20AC

	jmp	UpdateBgBufPtr
.endproc

left_digit_table:
	.repeat 10, I
		.repeat 10
			.byte I
		.endrep
	.endrep
right_digit_table:
	.repeat 10
		.repeat 10, I
			.byte I
		.endrep
	.endrep

digit_tile_1_1: .byte $07,$00,$0C,$0C,$0B,$07,$07,$0C,$07,$07
digit_tile_2_1: .byte $0B,$00,$10,$0F,$13,$13,$15,$00,$15,$13
digit_tile_3_1: .byte $09,$00,$09,$0E,$00,$0E,$09,$00,$09,$0E
digit_tile_1_2: .byte $08,$0D,$08,$08,$0D,$0C,$0C,$08,$08,$08
digit_tile_2_2: .byte $0D,$0D,$12,$14,$14,$11,$11,$0D,$14,$14
digit_tile_3_2: .byte $0A,$0D,$0E,$0A,$0D,$0A,$0A,$0D,$0A,$0A
