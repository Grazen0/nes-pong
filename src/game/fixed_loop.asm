.include "fixed_loop.inc"

.include "macros.inc"
.include "system.inc"
.include "constants.inc"
.include "variables.inc"
.include "subroutines.inc"

.segment "CODE"

.proc GameFixedLoop

.proc paddleAMovement
	lda	buttons
	and	#BTN_DOWN
	beq	down_skip

	lda	paddle_a_y
	cmp	#(WALL_BOTTOM - PADDLE_HEIGHT)	; Skip if already at border
	bcs	down_skip

	inc	paddle_a_y	; Paddle go down
	inc	paddle_a_y	; Paddle go down

	jmp	up_skip
down_skip:

	lda	buttons
	and	#BTN_UP
	beq	up_skip

	lda	paddle_a_y
	cmp	#(WALL_TOP + 1)
	BR_LEQ	up_skip

	dec	paddle_a_y	; Paddle go up
	dec	paddle_a_y
up_skip:
.endproc

.proc ballMovement
	;;; Move ball vertically
	lda	ball_y
	clc
	adc	ball_speed_y
	sta	ball_y
	
	cmp	#(WALL_BOTTOM - BALL_SIZE)
	bcs	bounce_y
	cmp	#(WALL_TOP + 1)
	BR_GT	:+

bounce_y:
	lda	ball_speed_y
	eor	#$FF
	; sec
	adc	#$00
	sta	ball_speed_y
:
	;;; Move ball horizontally
	lda	ball_x
	clc
	adc	ball_speed_x
	sta	ball_x

	lda	ball_speed_x
	bmi	left_collisions

	;;; Check for collisions to the right
	lda	ball_x
	cmp	#(PADDLE_A_X - BALL_SIZE)
	bcc	horizontal_end	; Ball hasn't reached the paddle (and border, ofc)

	cmp	#(SCREEN_WIDTH - PADDLE_MARGIN)
	bcs	check_border_col	; Ball has passed the paddle already
	
	;;; Ball is in horizontal range of the paddle
	;;; Check vertical range now
	lda	ball_y
	; clc
	adc	#(BALL_SIZE-1)	; (No need for clc, carry is already clear)
	cmp	paddle_a_y
	bcc	horizontal_end	; Ball is over paddle
	; sec
	sbc	#((BALL_SIZE-1)+PADDLE_HEIGHT)	; Recover ball_y, then subtract paddle height
	cmp	paddle_a_y
	bcs	horizontal_end	; Ball is under paddle

bounce_x:
	lda	ball_speed_x
	eor	#$FF
	; clc
	adc	#$01
	sta	ball_speed_x

	jmp	horizontal_end

check_border_col:
	cmp	#(SCREEN_WIDTH - BALL_SIZE)
	BR_LEQ	horizontal_end

	;;; Collision with the border on the right
	jsr	ResetBall
	jmp	horizontal_end

left_collisions:
	lda	ball_x
	;;; TODO

horizontal_end:
.endproc

.proc updateSpriteData
	lda	#$00		; Disable OAM transfer 
	sta	dma_enabled

	;;; Y positions are subtracted 1 because rendering sucks
	;;; Ball
	ldx	ball_y
	dex
	stx	spr_ball+SPR_Y
	lda	ball_x
	sta	spr_ball+SPR_X

	;;; Paddle A
	ldx	paddle_a_y
	dex			; Offset Y coordinate by -1 because rendering sucks
	txa
	ldx	#$00
	clc
update_paddle_a_loop:
	sta	sprs_paddle_a+SPR_Y, x
	adc	#$08
	inx
	inx
	inx
	inx
	cpx	#($04 * PADDLE_LEN)
	bne	update_paddle_a_loop
	
	lda	#$01		; Enable OAM transfer
	sta	dma_enabled
.endproc

	rts
.endproc
