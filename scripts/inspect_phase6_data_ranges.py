"""Survey all data/table/padding vs executable code regions across the 3 8502 ROMs for Phase 6."""
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from generate_disassembly import OPCODES_6502

b4 = (ROOT / "basic-4000.318018-02.bin").read_bytes()
b8 = (ROOT / "basic-8000.318019-02.bin").read_bytes()
kn = (ROOT / "kernal.318020-03.bin").read_bytes()

# Let's check where linear disassembly hits undocumented opcodes (fallback .BYTE) in each ROM!
def check_undocumented(data, base, known_ranges):
    rmap = set()
    for s, e, *_ in known_ranges:
        for a in range(s, e + 1):
            rmap.add(a)
    off = 0
    n = len(data)
    undoc = []
    while off < n:
        pc = base + off
        if pc in rmap:
            off += 1
            continue
        op = data[off]
        if op in OPCODES_6502:
            mnem, mode, length = OPCODES_6502[op]
            if off + length <= n and not any((pc + k) in rmap for k in range(1, length)):
                off += length
                continue
        undoc.append((pc, op))
        off += 1
    return undoc

b4_ranges = [
    (0x4107, 0x4141, "BASIC 7.0 Startup Sign-On Banner Strings", "identified_data"),
    (0x4197, 0x419A, "MMU Preconfiguration Register Init Table ($D501-$D504)", "identified_data"),
    (0x4231, 0x4234, "Default Sprite / Scaling Init Bytes", "identified_data"),
    (0x4417, 0x4608, "Primary Keyword Token Table (126 Tokens, $80-$FD)", "identified_data"),
    (0x4609, 0x46C8, "Extended $FE Statement Keyword Table (37 Tokens, $FE $02-$26)", "identified_data"),
    (0x46C9, 0x46FB, "Extended $CE Function Keyword Table (9 Tokens, $CE $02-$0A)", "identified_data"),
    (0x46FC, 0x47D7, "Statement Dispatch Vector Table (STMDSP, 110 RTS-1 Vectors)", "identified_data"),
    (0x47D8, 0x4827, "Function Dispatch Vector Table (FUNDSP, 40 Direct Vectors)", "identified_data"),
    (0x4828, 0x4845, "Operator Precedence & Dispatch Table (OPTAB, 10 Entries)", "identified_data"),
    (0x484B, 0x4A81, "BASIC 7.0 Error Message String Table (41 Messages, $01-$29)", "identified_data"),
    (0x4D1F, 0x4D2B, "Error Handler Message Fragments (' ERROR', ' IN ')", "identified_data"),
    (0x4D2D, 0x4D36, "READY. Prompt String", "identified_data"),
    (0x5288, 0x528E, "BREAK Message String", "identified_data"),
    (0x63F5, 0x640A, "Embedded Designer Credits (FRED B / TERRY R / MIKE I)", "identified_data"),
    (0x6BC4, 0x6BC8, "GRAPHIC Mode Flag Bitmask Table", "identified_data"),
    (0x6CB3, 0x6CBA, "Bitmask Powers-of-Two Table ($01..$80)", "identified_data"),
    (0x6DDA, 0x6DE2, "PLAY Musical Note Semitone Offset Table", "identified_data"),
    (0x6FE4, 0x7045, "PLAY & ENVELOPE Parameter Lookup Tables", "identified_data"),
    (0x7E82, 0x7FFD, "Unused ROM Padding ($FF)", "padding"),
    (0x7FFE, 0x7FFF, "ROM Revision and Checksum Trailer", "identified_data"),
]

u4 = check_undocumented(b4, 0x4000, b4_ranges)
print(f"B4 undocumented/data fallbacks ({len(u4)}):", [f"${p:04X}:{b:02X}" for p, b in u4[:40]])
