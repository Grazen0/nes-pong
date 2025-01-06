.include "controller.inc"

.segment "ZEROPAGE"
buttons:    .res 1  

.segment "CODE"

.proc read_joypad
    lda    #$01
    sta    JOYPAD_1
    sta    buttons
    lsr    a        ; A = 0
    sta    JOYPAD_1
    
read_loop:
    lda    JOYPAD_1
    lsr    a
    rol    buttons
    bcc    read_loop

    rts
.endproc

.exportzp buttons
.export read_joypad
