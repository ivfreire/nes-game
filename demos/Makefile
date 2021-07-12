INPUT = platformer

all $(INPUT):
	ca65 $(INPUT).asm -o $(INPUT).o -t nes
	ld65 $(INPUT).o -o $(INPUT).nes -t nes
	nestopia $(INPUT).nes