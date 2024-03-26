.include "macros.inc"
.include "system.inc"
.include "random.inc"
.include "controller.inc"
.include "video/macros.inc"
.include "video/draw_buffer.inc"
.include "game/fixed_loop.inc"
.include "game/init.inc"

.segment "HEADER"
	.byte "NES", $1A
	.byte $01	; 2 * 16 KB of PRG ROM
	.byte $01	; 1 * 8 KB of CHR ROM
	.byte %00000000 ; Some flags

.segment "CODE"

;;; NMI (VBLANK) -----------------------------------------
.proc NMI
	pha
	txa
	pha
	tya
	pha

	;;; Transfer sprite data to PPU OAM
	lda	dma_enabled
	beq	:+
	lda	#$00
	sta	OAM_ADDR
	lda	#>OAM
	sta	OAM_DMA
:	
	;;; Draw buffer
	lda	draw_enabled
	beq	:+
	jsr	DrawBuffer
:
	;;; Restore PPU_CTRL and scroll after VRAM writes
	lda	soft_ppu_ctrl
	sta	PPU_CTRL
	lda	soft_ppu_mask
	sta	PPU_MASK

	bit	PPU_STATUS	; Latch (?)
	lda	#$00
	sta	PPU_SCROLL
	sta	PPU_SCROLL

	; lda	#$00
	sta	sleeping	; Clear sleeping flag

	pla
	tay
	pla
	tax
	pla
	rti
.endproc

;;; Main code --------------------------------------------
.proc RESET
	sei	; Disable IRQs
	cld	; Disable decimal mode
	
	ldx	#$FF	; Set up stack
	txs

	inx			; X = 0
	stx	PPU_CTRL	; Disable NMI
	stx	PPU_MASK	; Disable rendering
	stx	APU_STATUS	; Disable sound
	stx	APU_DMC_CTRL	; Disable DMC IRQs
	stx	dma_enabled	; Disable OAM transfer
	stx	draw_enabled	; Disable buffer drawing
	lda	#$40
	sta	APU_FC		; Disable APU IRQs

	bit	PPU_STATUS	; Clear VBL flag just in case
	WAIT_VBLANK_FISHY

	;;; Reset OAM sprite data
	;;; At this point, X = 0
	lda	#$FF
clear_oam_loop:
	sta	OAM, x
	inx
	bne	clear_oam_loop

	WAIT_VBLANK_FISHY

	;;; LOAD PALETTES
	LD_PPU_ADDR	$3F00
	lda	#$0F		; Black
	sta	PPU_DATA
	lda	#$30		; White
	sta	PPU_DATA
	lda	#$00		; Gray
	sta	PPU_DATA
	
	LD_PPU_ADDR	$3F10
	lda	#$0F		; Black
	sta	PPU_DATA
	lda	#$30		; White
	sta	PPU_DATA

	jsr	ResetBufPtr

	jsr	GameInit

	;;; FINAL INIT
	ldx	#$01
	stx	dma_enabled	; Enable OAM transfer
	stx	draw_enabled	; Enable buffer drawing

	dex	; X = 0
	stx	sleeping

	lda	#%00011110	; Enable sprites and background
	sta	soft_ppu_mask

	lda	#%10000000	; Enable NMIs, sprites pattern table 0, bg pattern table 0, bg nametable 0
	sta	PPU_CTRL
	sta	soft_ppu_ctrl

main_loop:
	inc	sleeping	; sleeping = $01

waiting_for_vblank:
	lda	rng_seed
	sec
	adc	buttons
	sta	rng_seed

	lda	sleeping
	bne	waiting_for_vblank
	
	;;; NMI HAS FINISHED

	jsr	ReadJoypad
	jsr	GameFixedLoop

	jmp	main_loop
.endproc

.segment "VECTORS"
	.word NMI
	.word RESET

.segment "CHARS"
	.incbin "res/graphics.chr"
