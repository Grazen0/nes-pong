.ifndef __LIB_PSEUDO_OPS_INC__
__LIB_PSEUDO_OPS_INC__ = 1

;;; STore Word
;;; addr = #word
.macro STW word, addr
	lda	#<word
	sta	addr
	lda	#>word
	sta	addr+1
.endmacro

;;; ADd to Memory with Carry
.macro ADMC addr, val
	lda	addr
	adc	val
	sta	addr
.endmacro

;;; NEGate
;;; A = ~A
.macro NEG addr
	.ifnblank addr
		lda	addr
	.endif
	eor	#$FF
	sec
	adc	#$00
	.ifnblank addr
		sta	addr
	.endif
.endmacro

;;; ToGgle Carry
;;; C = ~C
.macro TGC
	rol	a
	eor	#$01
	ror	a
.endmacro

;;; BRanch if Greater Than
.macro BR_GT addr
	bcc	gt_skip
	bne	addr
gt_skip:
.endmacro

;;; BRanch if LEss than or eQual
.macro BR_LEQ addr
	bcc	addr
	beq	addr
.endmacro

;;; ComPare Range (carry Set)
;;; C = min <= A <= max
.macro CPR_S min, max
	clc
	adc	#($FF - max)
	adc	#(max - min + 1)
.endmacro

;;; ComPare Range (carry Clear)
;;; C = ~(min <= A <= max)
.macro CPR_C min, max
	sec
	sbc	#min
	sbc	#(max - min + 1)
.endmacro

;;; MINimum value
;;; A = min(A, val)
.macro MIN val
	cmp	val
	bcc	@min_skip
	lda	val
@min_skip:
.endmacro

;;; MAXimum value
;;; A = max(A, val)
.macro MAX val
	cmp	val
	bcs	@max_skip
	lda	val
@max_skip:
.endmacro

.endif
