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

	LDA #%00100001
	STA $2001



Forever:
	JMP	Forever

MNI:
	RTI

.segment "VECTORS"
	.word MNI
	.word Reset

.segment "CHARS"
	.incbin "mario.chr"