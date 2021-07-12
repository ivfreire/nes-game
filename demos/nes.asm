; Wait for PPU to be ready
vblankwait:
	BIT $2002
	BPL vblankwait
	RTS

; Clear memory while loading
clrmem:
	LDX #$00
@Loop:
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
	CPX #$00
	BEQ @Loop
	RTS