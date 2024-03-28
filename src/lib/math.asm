.include "math.inc"

.segment "ZEROPAGE"
dec_digits: .res 3

.segment "CODE"

.proc DivideBy10
	ldx	#$00
	rol
	rol
.endproc

.proc BinToDec

.endproc

;;;  O
;;; ≤))≥ 
;;; _|\_