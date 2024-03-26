.include "system.inc"

.segment "ZEROPAGE"
sleeping:	.res 1	; bool

game_state:	.res 1	; u8 (0 = menu, 1 = game, 2 = game over)

dma_enabled:	.res 1	; bool
draw_enabled:	.res 1	; bool
soft_ppu_ctrl:	.res 1	; mask
soft_ppu_mask:	.res 1	; mask
