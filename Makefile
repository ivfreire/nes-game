INPUT = src/game.asm
OUTPUT = nes-game
BUILD = build

all $(INPUT):
	ca65 $(INPUT) -o $(BUILD)/$(OUTPUT).o -t nes
	ld65 $(BUILD)/$(OUTPUT).o -o $(OUTPUT).nes -t nes