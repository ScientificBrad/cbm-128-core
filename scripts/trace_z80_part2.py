#!/usr/bin/env python3
"""
Disassemble the remaining Z80 BIOS sections ($00EE-$00FF, $0526-$0D19, and 8502 payload $0D1A-$0F03).
"""
from pathlib import Path
import struct
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from trace_z80_sections import disasm_z80_range, disasm_6502_range

if __name__ == "__main__":
    disasm_z80_range(0x00EE, 0x0100)
    disasm_z80_range(0x0526, 0x0D1A)
    disasm_6502_range(0x0D1A, 0x0D22, 0x1100)
    disasm_6502_range(0x0D22, 0x0EE5, 0x3000)
    disasm_6502_range(0x0EE5, 0x0F04, 0xFFD0)
