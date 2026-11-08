# Commodore 128 Firmware Disassembly and Reconstruction

This directory contains the reconstructed 6502/8502 and Z80 source code extracted during reverse engineering of the genuine Commodore 128 ROM set.

## Structure

- `8502/`: MOS 8502 KERNAL and BASIC 7.0 assembly sources:
  - `kernal_c000.asm`: Reset vectors, I/O drivers, MMU initialization, interrupt handlers.
  - `basic_4000.asm`: Commodore BASIC 7.0 lower token parser and statement interpreter.
  - `basic_8000.asm`: Extended graphics, sound (SOUND/ENVELOPE), and disk commands.
- `z80/`: Zilog Z80 BIOS source code:
  - `z80bios.asm`: 4 KB bootstrap BIOS executing from `$0000-$0FFF` in Z80 address space.
  - `cpm_loader.asm`: Sector loader and CP/M 3.0 handover routines.
- `character_rom/`: Character font generator definitions and bit patterns (Standard 40-col and 80-col).

## Verification Tools

- `verify_roms.py`: Validates dumps against known-good Commodore engineering release checksums.
- `build_roms.py`: Re-assembles reconstructed source code and checks for bit-identical binary generation.
