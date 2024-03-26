.include "variables.inc"

.include "system.inc"
.include "constants.inc"

.segment "ZEROPAGE"

ball_x:		.res 1	; u8
ball_y:		.res 1	; u8
ball_speed_x:	.res 1	; i8
ball_speed_y:	.res 1	; i8

paddle_a_y:	.res 1	; u8
paddle_b_y:	.res 1	; u8

player_a_score:	.res 1	; u8
player_b_score:	.res 1	; u8

.segment "OAM"
.org OAM ; FIX

spr_ball:	.res $04
sprs_paddle_a:	.res $04 * PADDLE_LEN
sprs_paddle_b:	.res $04 * PADDLE_LEN

.reloc
