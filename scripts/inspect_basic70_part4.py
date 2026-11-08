#!/usr/bin/env python3
"""
Phase 5 Part 4: Exact decode of all BASIC 7.0 tables, FRMEVL, PTRGET, Control Flow,
Key Commands, and ML Monitor ($B000-$BFFF).
"""
from pathlib import Path
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import read_rom_byte, read_rom_slice, disasm_range

def dump_tables_exact():
    for addr in range(0x46C0, 0x4850, 16):
        chunk = read_rom_slice(addr, 16)
        h = " ".join(f"{b:02X}" for b in chunk)
        a = "".join(chr(b & 0x7F) if 32 <= (b & 0x7F) <= 126 else "." for b in chunk)
        print(f"  ${addr:04X}: {h:<48} |{a}|")

if __name__ == "__main__":
    dump_tables_exact()
    disasm_range(0x77D0, 0x7E00, "EXPRESSION EVALUATOR (FRMEVL / EVAL) & VARIABLE LOOKUP (PTRGET)")
