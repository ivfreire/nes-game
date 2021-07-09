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

loadPallets:
	LDA $2002
	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
	LDX #$00
loadPalletsLoop:
	LDA PaletteData, X
	STA $2007
	INX
	CPX #$20
	BNE loadPalletsLoop

loadSprites:
	LDX 0
loadSpritesLoop:
	LDA sprites, X
	STA $0200, X
	INX
	CPX #$10
	BNE loadSpritesLoop

	LDA #%10000000
	STA $2000
	LDA #%00010110
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
	LDA $4016	; Up
	LDA $4016	; Down

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

	RTI

sprites:
	.byte $80, $32, $00, $80   ;sprite 0
	.byte $80, $33, $00, $88   ;sprite 1
	.byte $88, $34, $00, $80   ;sprite 2
	.byte $88, $35, $00, $88   ;sprite 3

PaletteData:
 	.byte $0F, $31, $32, $33, $0F, $35, $36, $37, $0F, $39, $3A, $3B, $0F, $3D, $3E, $0F  ; background palette data
 	.byte $0F, $1C, $15, $14, $0F, $02, $38, $3C, $0F, $1C, $15, $14, $0F, $02, $38, $3C  ; sprite palette data

.segment "VECTORS"
	.word MNI
	.word Reset

.segment "CHARS"
	.incbin "mario.chr"