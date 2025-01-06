.linecont +

.include "pseudo_ops.inc"
.include "system.inc"

.segment "HEADER"
.byte "NES", $1A    ; Required header
.byte $01           ; 1 * 16 KB of PRG ROM
.byte $01           ; 1 * 8 KB of CHR ROM
.byte %00000000     ; Some flags

.segment "CODE"

.proc reset
    .importzp rng_seed                                                  ; lib/random.asm
    .import draw_bg_buffer, reset_bg_buf_ptr                            ; lib/nes/bg_buffer.asm
    .importzp buttons                                                   ; lib/nes/controller.asm
    .import read_joypad                                                 ; '
    .import game_fixed_loop                                             ; game/fixed_loop.asm
    .importzp sleeping, soft_ppu_ctrl, soft_ppu_mask, nmi_enabled, \
        dma_enabled, draw_enabled                                       ; lib/nes/system.inc
    .import game_init                                                   ; game/init.asm

    sei    ; Disable IRQs
    cld    ; Disable decimal mode
    
    ldx     #$FF    ; / Set up stack
    txs             ; \

    inx                     ; X = 0
    stx     PPU_CTRL        ; Disable NMIs
    stx     PPU_MASK        ; Disable rendering
    stx     APU_STATUS      ; Disable sound
    stx     APU_DMC_CTRL    ; Disable DMC IRQs
    ; stx    dma_enabled      ; Disable OAM transfer
    ; stx    draw_enabled     ; Disable buffer drawing
    lda     #$40            ; / Disable APU IRQs
    sta     APU_FC          ; \

    stx     soft_ppu_ctrl    ; These still need 0,
    stx     soft_ppu_mask    ; but aren't as critical

    bit     PPU_STATUS  ; Clear VBL flag just in case
    WAIT_VBLANK_FISHY

    ;;; Reset OAM sprite data
    ;;; At this point, X = 0
    lda     #$FF
clear_oam_loop:
    sta     OAM, x
    inx
    bne     clear_oam_loop

    WAIT_VBLANK_FISHY

    ;;; Load palettes
    LD_PPU_ADDR    $3F00
    lda     #$0F        ; Black
    sta     PPU_DATA
    lda     #$30        ; White
    sta     PPU_DATA
    lda     #$00        ; Gray
    sta     PPU_DATA
    
    LD_PPU_ADDR    $3F10
    lda     #$0F        ; Black
    sta     PPU_DATA
    lda     #$30        ; White
    sta     PPU_DATA

    jsr     reset_bg_buf_ptr
    jsr     game_init

    ;;; FINAL INIT
    ldx     #$01
    stx     nmi_enabled     ; Enable NMI processing
    stx     dma_enabled     ; Enable OAM transfer
    stx     draw_enabled    ; Enable buffer drawing

    dex                 ; X = 0
    stx     sleeping

    lda     #%00011110    ; Enable sprites and background
    sta     soft_ppu_mask

    lda     #%10000000    ; Enable NMIs, sprites pattern table 0, bg pattern table 0, bg nametable 0
    sta     PPU_CTRL
    sta     soft_ppu_ctrl

main_loop:
    inc     sleeping    ; sleeping = $01

waiting_for_vblank:
    ;;; Use joypad input for RNG randomness
    lda     rng_seed
    adc     buttons
    sta     rng_seed

    lda     sleeping
    bne     waiting_for_vblank
    
    ;;; NMI HAS FINISHED

    jsr     read_joypad
    jsr     game_fixed_loop

    jmp     main_loop
.endproc

.segment "VECTORS"
.import nmi ; game/nmi.asm

.word nmi
.word reset

.segment "CHARS"
.incbin "res/graphics.chr"
