# 👾️ NES-game

Nintendo Entertainment System (NES) was an 8-bit game console launched by Nintendo in 1983, in Japan, the console was a huge success around the world with great titles that inspired (and inspires) modern games nowadays.
This project has educational purposes only. I am creating this game so I can learn the fundations of assembly language and because it is fun :)

## Introduction

The NES console runs on an 8-bit microprocessor known as MOS Technology 6502 (aka 6502). There are other microprocessors in NES, the PPU (Picture Processing Unit) which deals with graphics and the APU (Audio Processing Unit) which process games' audio. And also, NES cartridges have other components, the ROM (Read-Only Memory) which stores the game code and/or game resources and optionally the WRAM (Work RAM) that is constantly powered on by an internal battery so it provides long term storage.

## Built-with

- [CC65](https://cc65.github.io/cc65) - compiler
- Nestopia - emulator

## Build

After intalling cc65 compiler, run

```sh
$ make
```

in the repository root.

## Developers

- [Ícaro Freire](https://github.com/ivfreire)

## Acknoledgements

Here are the resources and references used in this projects, check them out if you want to learn more about NES development.

- [Nerdy Nights Mirror](https://nerdy-nights.nes.science/)
- [NES Dev wiki](https://wiki.nesdev.com/w/index.php/Nesdev_Wiki/)
- [6502 opcodes](http://www.6502.org/tutorials/6502opcodes.html#INX)
