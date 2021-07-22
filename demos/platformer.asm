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
	.include	"nes.asm"

	buttons	.set %00000000

	.scope Player

Movement:
	LDX #$00
@Loop
	RTS

Controller:
	JSR	Movement
	RTS

	.endscope

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

	JSR vblankwait
	JSR clrmem			; clears RAM before game starts
	JSR vblankwait

	LDA #$80
	STA $0200
	STA $0203
	LDA #$00
	STA $0201
	STA $0202

	CLI 

	LDA #%10010000
	STA $2000
	LDA #%00011110
	STA $2001


Forever:
	JMP	Forever

Update:

	RTS

FetchController:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016
	LDX #$00
@Loop:
	LDA $4016
	ROR A
	ROL buttons
	INX
	CPX #$08
	BNE @Loop

	JSR	Player::Controller

	RTS

MNI:
	LDA #$00
	STA $2003
	LDA #$02
	STA $4014

	JSR Update
	JSR FetchController

	RTI

.segment "VECTORS"
	.word	MNI
	.word	Reset

.segment "CHARS"
	.byte %11111111, %11111111, %11111111, %11111111, %11111111, %11111111, %11111111, %11111111
	.byte %11111111, %11111111, %11111111, %11111111, %11111111, %11111111, %11111111, %11111111