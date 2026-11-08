"""Inspect KERNAL keyboard matrix decode tables ($FA80-$FC3A) and SCNKEY routine."""
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range, read_rom_slice

# Let's check ED_JSCNKEY at $C012 -> where does it jump?
disasm_range(0xC000, 0xC030, "Editor Jump Table ($C000-$C02F)")
disasm_range(0xC550, 0xC680, "Editor SCNKEY ($C55D)")

# Let's dump the unshifted and shifted 88-key tables at $FA80-$FB80
for title, addr in [
    ("Table 1 ($FA80, Unshifted)", 0xFA80),
    ("Table 2 ($FAD9, Shifted)", 0xFAD9),
    ("Table 3 ($FB32, Commodore C=)", 0xFB32),
    ("Table 4 ($FB8B, Control)", 0xFB8B),
]:
    raw = read_rom_slice(addr, 89)
    print(f"\n=== {title} ===")
    for row in range(11):
        rbytes = raw[row * 8 : (row + 1) * 8]
        desc = " ".join(f"{b:02X}({chr(b) if 32<=b<127 else '.'})" for b in rbytes)
        print(f"  Row {row:2d}: {desc}")
