"""Quick disassembly of POKE ($80E5), PEEK ($80C5), SYS ($5885), DRAW ($A36E), SPRITE ($6C4F), PLAY ($6BD7 -> $6DE4), BANK ($6BC9)."""
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range

disasm_range(0x80C5, 0x8120, "PEEK ($80C5) & POKE ($80E5)")
disasm_range(0x587B, 0x58DF, "DIM ($587B) & SYS ($5885)")
disasm_range(0xA36E, 0xA440, "DRAW ($A36E)")
disasm_range(0x6C4F, 0x6CBF, "SPRITE ($6C4F)")
