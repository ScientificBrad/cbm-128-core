"""Inspect remaining BASIC 7.0 commands (POKE, PEEK, SYS, DRAW,SPRITE,PLAY,BANK,MONITOR) and ML Monitor ($B300-$B480, $B980-$BFFF)."""
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range, read_rom_byte

# Let's check exact entry addresses from statement and function dispatch tables first!
# In statement table:
# POKE ($97 -> index 23 at $472A), SYS ($9E -> index 30 at $4738)
# DRAW ($F5 -> index 67 at $4782), SPRITE ($FE $07 -> index 78 at $4798)
# PLAY ($FE $0B -> index 82 at $47A0), BANK ($FE $02 -> index 73 at $478E)
# MONITOR ($FA -> index 72 at $478C)
# PEEK ($C2 -> func index 14 at $47F4)

def get_word(addr):
    return read_rom_byte(addr) | (read_rom_byte(addr + 1) << 8)

for name, addr, is_rts in [
    ("POKE", 0x46FC + (0x97 - 0x80)*2, True),
    ("SYS", 0x46FC + (0x9E - 0x80)*2, True),
    ("DRAW", 0x46FC + (0xF5 - 0x32 - 0x80)*2, True),
    ("MONITOR", 0x46FC + (0xFA - 0x32 - 0x80)*2, True),
    ("BANK", 0x46FC + (0x02 + 0x47)*2, True),
    ("SPRITE", 0x46FC + (0x07 + 0x47)*2, True),
    ("PLAY", 0x46FC + (0x0B + 0x47)*2, True),
    ("PEEK", 0x47D8 + (0xC2 - 0xB4)*2, False),
]:
    w = get_word(addr)
    if is_rts:
        w = (w + 1) & 0xFFFF
    print(f"{name:<10} table@${addr:04X} -> ${w:04X}")

disasm_range(0x58E0, 0x5970, "POKE ($591E) & WAIT ($5927) & PEEK ($8815)")
disasm_range(0x8800, 0x8830, "GETADR ($8812) & PEEK ($8815)")
disasm_range(0x5060, 0x5140, "SYS ($5064) & SAVING/RESTORING REGISTERS")
disasm_range(0x6400, 0x652B, "DRAW ($641B)")
disasm_range(0x6FD0, 0x70E5, "SPRITE ($70A7) & MOVSPR")
disasm_range(0x9EF0, 0x9F8A, "PLAY ($6D78?) & GRAPHIC ALLOC ($9F4F)")
disasm_range(0x6D60, 0x6E30, "PLAY ($6D78) & TEMPO ($6E08)")
disasm_range(0x76D0, 0x7760, "BANK ($7712),BVERIFY,BSAVE,BLOAD")
disasm_range(0xB300, 0xB485, "ML Monitor Hunt (H), Load/Save/Verify (L/S/V), Assemble (A/.)")
disasm_range(0xB980, 0xBAB0, "ML Monitor Helpers & Disk (@) Command ($B9B1)")
