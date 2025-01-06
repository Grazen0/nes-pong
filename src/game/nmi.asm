.linecont +

.include "system.inc"

.proc nmi
    .import draw_bg_buffer                                              ; lib/nes/bg_buffer.asm
    .importzp sleeping, soft_ppu_mask, soft_ppu_ctrl, draw_enabled, \
        dma_enabled, nmi_enabled                                        ; lib/nes/system.asm

    pha
    lda     nmi_enabled
    beq     skip_nmi
    
    txa
    pha
    tya
    pha

    ;;; Transfer sprite data to PPU OAM
    lda     dma_enabled
    beq     :+
    lda     #$00
    sta     OAM_ADDR
    lda     #>OAM
    sta     OAM_DMA
:    
    ;;; Draw buffer
    lda     draw_enabled
    beq     :+
    jsr     draw_bg_buffer
:
    ;;; Update real PPU_CTRl and PPU_MASK
    lda     soft_ppu_ctrl
    sta     PPU_CTRL
    lda     soft_ppu_mask
    sta     PPU_MASK

    ;;; Restore PPU_CTRL and scroll after VRAM writes
    bit     PPU_STATUS    ; Latch (?)
    lda     #$00
    sta     PPU_SCROLL
    sta     PPU_SCROLL

    ; lda     #$00
    sta     sleeping    ; Clear sleeping flag

    pla
    tay
    pla
    tax
skip_nmi:
    pla
    rti
.endproc

.export nmi
