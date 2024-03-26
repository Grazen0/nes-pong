.ifndef __DRAW_BUFFER_INC__
__DRAW_BUFFER_INC__ = 1

.macro BUF_DRAW_RUN dest, len, data, dir
	ldy	#$00

	lda	#>dest
	sta	(buf_ptr), y
	iny
	lda	#<dest
	sta	(buf_ptr), y
	iny
	lda	#($40 | dir | (len - 1))
	sta	(buf_ptr), y
	iny
	lda	#data
	sta	(buf_ptr), y
	iny

	lda	buf_ptr
	clc
	adc	#$04
	sta	buf_ptr
.endmacro

.globalzp buf_ptr
.global DRAW_BUF_ADDR

.global ResetBufPtr
.global DrawBuffer

.endif
