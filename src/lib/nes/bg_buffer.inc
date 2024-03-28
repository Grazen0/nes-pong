.ifndef __DRAW_BUFFER_INC__
__DRAW_BUFFER_INC__ = 1

BG_BUF_ADDR = $0700
.if <BG_BUF_ADDR <> $00
	.error "BG_BUF_ADDR must be aligned with $0100"
.endif

DRAW_RIGHT	= %00000000
DRAW_DOWN	= %10000000
DRAW_LIT	= %00000000
DRAW_RUN	= %01000000

.globalzp bg_buf_ptr

.global UpdateBgBufPtr
.global ResetBgBufPtr
.global DrawBgBuffer

.macro BG_BUF_ENTRY_SETUP dest, len, flags
	lda	#<dest
	sta	(bg_buf_ptr), y
	iny
	lda	#>dest
	sta	(bg_buf_ptr), y
	iny
	lda	#(flags | (len - 1))
	sta	(bg_buf_ptr), y
	iny
.endmacro

.macro BG_BUF_PUSH_RUN dest, len, data, draw_dir
	BG_BUF_ENTRY_SETUP dest, len, (draw_dir | DRAW_RUN)
	
	lda	#data
	sta	(bg_buf_ptr), y

	jsr	UpdateBgBufPtr
.endmacro

.endif
