.include "system.inc"

.segment "ZEROPAGE"
sleeping:	.res 1	; bool

game_state:	.res 1	; u8 (0 = menu, 1 = game, 2 = game over)

nmi_enabled:	.res 1	; bool
dma_enabled:	.res 1	; bool
draw_enabled:	.res 1	; bool

soft_ppu_ctrl:	.res 1	; mask
soft_ppu_mask:	.res 1	; mask

player_a_score:	.res 1	; u8
player_b_score:	.res 1	; u8
