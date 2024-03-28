.include "variables.inc"

.include "system.inc"
.include "constants.inc"

.segment "ZEROPAGE"
.org STATE_ZP

ball_x:		.res 1	; u8
ball_y:		.res 1	; u8
ball_speed_x:	.res 1	; i8
ball_speed_y:	.res 1	; i8

paddle_a_y:	.res 1	; u8
paddle_b_y:	.res 1	; u8

.reloc

.segment "OAM"
.org OAM ; FIX

spr_ball:	.res $04
sprs_paddle_a:	.res $04 * PADDLE_TILES
sprs_paddle_b:	.res $04 * PADDLE_TILES

.reloc
