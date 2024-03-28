.include "random.inc"

.segment "ZEROPAGE"
rng_seed:	.res 1

.segment "CODE"

.proc RandomByte
	lda	rng_seed
	beq	do_eor
	asl
	beq	no_eor
	bcc	no_eor
do_eor:
	eor	#$1D
no_eor:
	sta	rng_seed
	rts
.endproc
