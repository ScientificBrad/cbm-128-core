"""Targeted inspection of BASIC 7.0 commands, extended functions, and ML Monitor ($B000-$BFFF)."""
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range

# 1. Extended function dispatch at $4C35-$4CB5 and $81C0-$8370
disasm_range(0x4C35, 0x4CB5, "Function Dispatcher ($B4..$D4 and $CE prefix)")
disasm_range(0x81C0, 0x8370, "C128 Extended Functions (RGR, RCLR, $CE prefix, ERR$, etc.)")

# 2. Key BASIC 7.0 Commands
disasm_range(0x555A, 0x56A5, "PRINT ($555A) & INPUT ($5662)")
disasm_range(0x6B5A, 0x6C40, "GRAPHIC ($6B5A)")
disasm_range(0x652B, 0x65B0, "DRAW ($652B)")
disasm_range(0x62B7, 0x6360, "BOX ($62B7)")
disasm_range(0x668E, 0x6740, "CIRCLE ($668E)")
disasm_range(0x61A8, 0x6260, "PAINT ($61A8)")
disasm_range(0x70E1, 0x7250, "SPRITE ($70E1), BANK ($7190), SOUND ($71EC)")
disasm_range(0x9F8A, 0xA050, "PLAY ($9F8A)")

# 3. ML Monitor ($B000-$BFFF)
disasm_range(0xB000, 0xB300, "ML Monitor Entry, BRK, Parser, R, M, G, J, X")
disasm_range(0xB480, 0xB850, "ML Monitor Assembler (A/.), F, T, C, H, L, S, V")
