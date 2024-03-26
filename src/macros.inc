.ifndef __MACROS_ASM__
__MACROS_ASM__ = 1

;;; Branch if greater than
.macro BR_GT addr
	bcc	gt_skip
	bne	addr
gt_skip:
.endmacro

;;; Branch if less than or equal
.macro BR_LEQ addr
	bcc	addr
	beq	addr
.endmacro

;;; A = min(A, val)
.macro MIN val
	cmp	val
	bcc	:+
	lda	val
:	
.endmacro

;;; A = max(A, val)
.macro MAX val
	cmp	val
	bcs	:+
	lda	val
:	
.endmacro

.endif
