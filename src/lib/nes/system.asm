.linecont +

.segment "ZEROPAGE"
sleeping: .res 1    ; bool

nmi_enabled:    .res 1    ; bool
dma_enabled:    .res 1    ; bool
draw_enabled:   .res 1    ; bool

soft_ppu_ctrl:  .res 1    ; mask
soft_ppu_mask:  .res 1    ; mask

player_a_score: .res 1    ; u8
player_b_score: .res 1    ; u8

.exportzp sleeping, nmi_enabled, dma_enabled, draw_enabled, soft_ppu_ctrl, \
    soft_ppu_mask, player_a_score, player_b_score
