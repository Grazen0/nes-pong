.ifndef __VIDEO_MACROS_INC__
__VIDEO_MACROS_INC__ = 1

.macro LD_PPU_ADDR addr
	bit	PPU_STATUS	; Reset the PPU_ADDR latch
	lda	#>addr		; High byte
	sta	PPU_ADDR
	lda	#<addr		; Low byte
	sta	PPU_ADDR
.endmacro

.macro WAIT_VBLANK_FISHY
:	bit	PPU_STATUS
	bpl	:-
.endmacro

.endif
