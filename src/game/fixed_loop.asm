.include "fixed_loop.inc"

.include "system.inc"
.include "pseudo_ops.inc"
.include "controller.inc"
.include "constants.inc"
.include "variables.inc"
.include "subroutines.inc"


.segment "CODE"

.proc GameFixedLoop

.proc paddleAMovement
	;;; DOWN
	lda	buttons
	and	#BTN_DOWN
	beq	:+
	
	lda	paddle_a_y
	clc
	adc	#PADDLE_A_SPEED			; Paddle go up, but...
	MIN	#(WALL_BOTTOM - PADDLE_HEIGHT)	; ...keep inside wall
	sta	paddle_a_y
	
	jmp	end
:
	;;; UP
	lda	buttons
	and	#BTN_UP
	beq	end
	
	lda	paddle_a_y
	sec
	sbc	#PADDLE_A_SPEED	; Paddle go up, but...
	MAX	#(WALL_TOP + 1)	; ...keep inside wall
	sta	paddle_a_y
end:
.endproc

.proc paddleBMovement
	lda	paddle_b_y
	clc
	adc	#(PADDLE_HEIGHT / 2)	
	cmp	ball_y

	lda	paddle_b_y
	bcc	move_down
move_up:
	; sec
	sbc	#PADDLE_B_SPEED
	MAX	#(WALL_TOP + 1)
	sta	paddle_b_y

	jmp	end
move_down:
	; clc
	adc	#PADDLE_B_SPEED
	MIN	#(WALL_BOTTOM - PADDLE_HEIGHT)
	sta	paddle_b_y
end:
.endproc

.proc ballMovement
	;;; VERTICAL
	lda	ball_y
	clc
	adc	ball_speed_y
	sta	ball_y
	
	;;; Check for bounce
	cmp	#(WALL_BOTTOM - BALL_SIZE)
	bcs	bounce_y
	cmp	#(WALL_TOP + 1)
	BR_GT	:+
bounce_y:
	NEG	ball_speed_y	; Could be optimized, carry is already set
:
	;;; HORIZONTAL
	lda	ball_x
	clc
	adc	ball_speed_x
	sta	ball_x

	bit	ball_speed_x
	bmi	left_collisions

	;;; RIGHT COLLISIONS
	;;; Check for paddle horizontal range
	CPR_C	(PADDLE_A_X - BALL_SIZE), (PADDLE_A_X + PADDLE_WIDTH - 1)
	bcs	no_paddle_a_col

	;;; Ball is in horizontal range of the paddle
	;;; Check vertical range now
	lda	ball_y
	; clc
	adc	#(BALL_SIZE - 1)
	cmp	paddle_a_y
	bcc	end					; Ball is over paddle
	; sec
	sbc	#(BALL_SIZE - 1 + PADDLE_HEIGHT)	; Recover ball_y, then subtract PADDLE_HEIGHT
	cmp	paddle_a_y
	bcs	end					; Ball is under paddle

	;;; Bounce
	NEG	ball_speed_x	; Could be optimized, carry is already clear
	jmp	end

no_paddle_a_col:
	lda	ball_x
	cmp	#(SCREEN_WIDTH - BALL_SIZE + 1)
	bcc	end

	;;; Collision with the border on the right
	inc	player_b_score
	jsr	DrawPlayerBScore
	jsr	ResetBall
	jmp	end

left_collisions:
	;;; LEFT COLLISIONS
	;;; Check for paddle horizontal range
	CPR_C	(PADDLE_B_X - BALL_SIZE + 1), (PADDLE_B_X + PADDLE_WIDTH)
	bcs	no_paddle_b_col

	;;; Ball is in horizontal range of the paddle
	;;; Check vertical range now
	lda	ball_y
	; clc
	adc	#(BALL_SIZE - 1)
	cmp	paddle_b_y
	bcc	end					; Ball is over paddle
	; sec
	sbc	#(BALL_SIZE - 1 + PADDLE_HEIGHT)	; Recover ball_y, then subtract PADDLE_HEIGHT
	cmp	paddle_b_y
	bcs	end

	;;; Bounce
	NEG	ball_speed_x
	jmp	end		

no_paddle_b_col:
	lda	ball_x
	cmp	#$00
	bne	end

left_wall_collided:
	inc	player_a_score
	jsr	ResetBall
end:
.endproc

.proc updateSpriteData
	lda	#$00		; Disable OAM transfer 
	sta	dma_enabled

	;;; Y positions are subtracted 1 because rendering sucks
	;;; Ball
	ldx	ball_y
	dex
	stx	spr_ball+Sprite::Y_POS
	lda	ball_x
	sta	spr_ball+Sprite::X_POS

	;;; Paddle A
	ldx	paddle_a_y
	dex			; Offset Y coordinate by -1 because rendering sucks
	txa
	ldx	#$00
	clc
update_paddle_a_loop:
	sta	sprs_paddle_a+Sprite::Y_POS, x
	adc	#$08
	inx
	inx
	inx
	inx
	cpx	#($04 * PADDLE_TILES)
	bne	update_paddle_a_loop
	
	;;; Paddle B
	ldx	paddle_b_y
	dex			; Offset Y coordinate by -1 because rendering sucks
	txa
	ldx	#$00
	clc
update_paddle_b_loop:
	sta	sprs_paddle_b+Sprite::Y_POS, x
	adc	#$08
	inx
	inx
	inx
	inx
	cpx	#($04 * PADDLE_TILES)
	bne	update_paddle_b_loop
	
	lda	#$01		; Enable OAM transfer
	sta	dma_enabled
.endproc

	rts
.endproc
