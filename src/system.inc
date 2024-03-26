.ifndef __SYSTEM_INC__
__SYSTEM_INC__ = 1

;;; PPU
PPU_CTRL	= $2000
PPU_MASK	= $2001
PPU_STATUS	= $2002
OAM_ADDR	= $2003
OAM_DATA	= $2004
PPU_SCROLL	= $2005
PPU_ADDR	= $2006
PPU_DATA	= $2007
OAM_DMA		= $4014

;;; APU
APU_DMC_CTRL 	= $4010
APU_STATUS	= $4015
APU_FC		= $4017

;;; Display constants
TILE_ROWS	= 30
TILE_COLUMNS	= 32
SCREEN_WIDTH	= 8 * TILE_COLUMNS
SCREEN_HEIGHT	= 8 * TILE_ROWS
SCREEN_MIDDLE_X	= SCREEN_WIDTH / 2
SCREEN_MIDDLE_Y	= SCREEN_HEIGHT / 2

OAM = $0200

.globalzp sleeping

.globalzp game_state
.globalzp buttons

.globalzp dma_enabled
.globalzp draw_enabled
.globalzp soft_ppu_ctrl
.globalzp soft_ppu_mask

.endif
