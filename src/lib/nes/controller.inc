.ifndef __CONTROLLER_INC__
__CONTROLLER_INC__ = 1

JOYPAD_1	= $4016
JOYPAD_2	= $4017

BTN_RIGHT	= 1 << 0
BTN_LEFT	= 1 << 1
BTN_DOWN	= 1 << 2
BTN_UP		= 1 << 3
BTN_START	= 1 << 4
BTN_SELECT	= 1 << 5
BTN_B		= 1 << 6
BTN_A		= 1 << 7

.globalzp buttons

.global ReadJoypad

.endif
