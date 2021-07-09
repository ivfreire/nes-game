.segment "HEADER"
.byte "NES"
.byte $1a
.byte $02
.byte $01
.byte %00000000
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00

.segment "ZEROPAGE"

.segment "STARTUP"
Reset:
	SEI	; disable interruptions
	CLD	; disable decimal mode

	; disable sound IRQ
	LDX #$40
	STX $4017

	; initilize stack 
	LDX #$FF
	TXS

	INX

	; zero out PPU registers
	STX $2000
	STX $2001

	STX $4010
	
vblankwait:
	BIT $2002
	BPL vblankwait

	; clears RAM before game starts
clrmem:
	LDA #$00
	STA $0000, X
	STA $0100, X
	STA $0200, X
	STA $0300, X
	STA $0400, X
	STA $0500, X
	STA $0600, X
	STA $0700, X
	INX
	BEQ clrmem

vblankwait2:
	BIT $2002
	BPL vblankwait2


; +=== Loading stuff from RAM ===+ ;


loadPalletes:
	; $3F00 - $3F20: start address of palletes data
	LDA $2002
	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006

	LDX #$00
loadPalletesLoop:
	LDA PaletteData, X
	STA $2007
	INX
	CPX #$20
	BNE loadPalletesLoop

loadSprites:
	LDX 0
loadSpritesLoop:
	LDA sprites, X
	STA $0200, X
	INX
	CPX #$10
	BNE loadSpritesLoop

loadBackground:
	; $2000 - $2C30: Background nametable - 960 bytes
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006

	LDX #$00
loadBackgroundLoop:
	LDA background, X
	STA $2007
	INX
	CPX #$80
	BNE loadBackgroundLoop

loadAttribute:
	; $23C0 - $23C8: background's nametable 0 attribute
	LDA $2002
	LDA #$23
	STA $2006
	LDA #$C0
	STA $2006
	LDX #$00
loadAttributeLoop:
	LDA attribute, X
	STA $2007
	INX
	CPX #$08
	BNE loadAttributeLoop

	; enable interrupts
	CLI

	LDA #%10010000
	STA $2000
	LDA #%00011110
	STA $2001

Forever:
	JMP	Forever

MNI:
	LDA #$00
	STA $2003
	LDA #$02
	STA $4014

LatchController:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016

	LDA $4016	; A
	LDA $4016	; B
	LDA $4016	; Select
	LDA $4016	; Start

readUp:
	LDA $4016	; Up
	AND #%00000001
	BEQ readUpDone

	LDA $0200
	SEC
	SBC #$01
	STA $0200
readUpDone:

readDown:
	LDA $4016	; Down
	AND #%00000001
	BEQ readDownDone

	LDA $0200
	CLC
	ADC #$01
	STA $0200
readDownDone:

readLeft:
	LDA $4016	; Left
	AND #%00000001
	BEQ readLeftDone

	LDA $0203
	SEC
	SBC #$01
	STA $0203
readLeftDone:

readRight:
	LDA $4016	; Right
	AND #%00000001
	BEQ readRightDone

	LDA $0203
	CLC
	ADC #$01
	STA $0203
readRightDone:

	LDA #$00
 	STA $2005
 	STA $2005

	RTI

attribute:
 	.byte %00000000, %00010000, %0010000, %00010000, %00000000, %00000000, %00000000, %00110000

background:
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24  ;;row 1
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24  ;;all sky ($24 = sky)
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24  ;;row 2
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24  ;;all sky
	.byte $24, $24, $24, $24, $45, $45, $24, $24, $45, $45, $45, $45, $45, $45, $24, $24  ;;row 3
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $53, $54, $24, $24  ;;some brick tops
	.byte $24, $24, $24, $24, $47, $47, $24, $24, $47, $47, $47, $47, $47, $47, $24, $24  ;;row 4
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $55, $56, $24, $24  ;;brick bottoms

sprites:
	.byte $80, $00, $00, $80   ;sprite 0
	.byte $80, $33, $00, $88   ;sprite 1
	.byte $88, $34, $00, $80   ;sprite 2
	.byte $88, $35, $00, $88   ;sprite 3

PaletteData:
 	.byte $22, $29, $1A, $0F, $22, $36, $17, $0F, $22, $30, $21, $0F, $22, $27, $17, $0F  ; background palette data
 	.byte $0F, $1C, $15, $14, $0F, $02, $38, $3C, $0F, $1C, $15, $14, $0F, $02, $38, $3C  ; sprite palette data

.segment "VECTORS"
	.word MNI
	.word Reset

.segment "CHARS"
	.incbin "mario.chr"