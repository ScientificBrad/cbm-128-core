#!/usr/bin/env python3
"""
Phase 5 Part 5: Disassemble BASIC 7.0 Control Flow ($5260-$5A50, $5DF0-$6150),
Strings & Garbage Collection ($85B0-$8780, $92E0-$93F0),
Key Commands (`POKE`/`PEEK`/`BANK` $80C0-$8180, `SYS` $5880-$58B5, `GRAPHIC` $6B50-$6BF0,
`DRAW`/`BOX`/`CIRCLE`/`PAINT`, `SPRITE`, `PLAY`/`SOUND`),
and the Machine Language Monitor ($B000-$BFFF).
"""
from pathlib import Path
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range

if __name__ == "__main__":
    disasm_range(0x5260, 0x5450, "RETURN, DATA, REM, IF/THEN/ELSE, ON, LET")
    disasm_range(0x57F0, 0x58B8, "NEXT, DIM, SYS, TRON/TROFF")
    disasm_range(0x59C0, 0x5A60, "GOSUB, GOTO, RUN, DO/LOOP/EXIT")
    disasm_range(0x5DF0, 0x60A0, "FOR, TRAP, RESUME, DO/LOOP/WHILE/UNTIL")
    disasm_range(0x80C0, 0x8260, "PEEK, POKE, HEX$, DEC, GO, RGR, RCLR, POINTER, ERR$")
    disasm_range(0xB000, 0xB450, "MACHINE LANGUAGE MONITOR ($B000-$B450)")
