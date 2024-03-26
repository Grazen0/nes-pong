.include "subroutines.inc"

.include "system.inc"
.include "random.inc"
.include "constants.inc"
.include "variables.inc"

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
