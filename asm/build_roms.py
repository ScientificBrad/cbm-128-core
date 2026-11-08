#!/usr/bin/env python3
"""
Phase 6: Controlled Deterministic Dual-Architecture ROM Builder (`asm/build_roms.py`).

Assembles the five reconstructed assembly source files:
  - asm/8502/basic_low.asm        -> reconstruction/build/basic-4000.318018-02.bin
  - asm/8502/basic_high.asm       -> reconstruction/build/basic-8000.318019-02.bin
  - asm/8502/kernal.asm           -> reconstruction/build/kernal.318020-03.bin
  - asm/z80/z80bios.asm           -> reconstruction/build/z80bios.bin
  - asm/character_rom/characters.asm -> reconstruction/build/characters.390059-01.bin

Supports:
  - Explicit `.ORG $xxxx` origin directives
  - Full MOS 8502 / 6502 instruction set with `.W` forced 16-bit absolute addressing disambiguation
    for zero-page addresses (`$0000-$00FF`) encoded with 3-byte absolute opcodes
  - Full Zilog Z80A instruction set (`.ARCH Z80`), including `CB`/`ED` prefixes, relative branches,
    and `RST` vectors
  - `.BYTE` data/table/padding directives
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))
from assemble_and_verify import assemble_file

BUILD_TARGETS = [
    ("asm/8502/basic_low.asm", "basic-4000.318018-02.bin", "MOS 8502", 0x4000, 16384),
    ("asm/8502/basic_high.asm", "basic-8000.318019-02.bin", "MOS 8502", 0x8000, 16384),
    ("asm/8502/kernal.asm", "kernal.318020-03.bin", "MOS 8502", 0xC000, 16384),
    ("asm/z80/z80bios.asm", "z80bios.bin", "Zilog Z80A", 0x0000, 4096),
    ("asm/character_rom/characters.asm", "characters.390059-01.bin", "Glyph Data", 0x0000, 8192),
]


def build_all_roms():
    build_dir = ROOT / "reconstruction" / "build"
    build_dir.mkdir(parents=True, exist_ok=True)

    results = []
    print("=" * 80)
    print("CBM-128-CORE PHASE 6 ROM BUILDER (asm/build_roms.py)")
    print("=" * 80)
    for rel_src, out_name, arch, base_addr, expected_len in BUILD_TARGETS:
        src_path = ROOT / rel_src
        out_path = build_dir / out_name
        rebuilt = assemble_file(str(src_path), str(out_path))
        ok_len = len(rebuilt) == expected_len
        status = "BUILT OK" if ok_len else f"LENGTH MISMATCH ({len(rebuilt)} != {expected_len})"
        print(f"  [{status}] {rel_src:34s} -> reconstruction/build/{out_name:26s} ({len(rebuilt):5d} B)")
        results.append({
            "source": rel_src,
            "output": f"reconstruction/build/{out_name}",
            "architecture": arch,
            "origin": f"${base_addr:04X}",
            "bytes_assembled": len(rebuilt),
            "expected_bytes": expected_len,
            "length_ok": ok_len,
        })
    print("=" * 80)
    return results


if __name__ == "__main__":
    res = build_all_roms()
    if not all(r["length_ok"] for r in res):
        sys.exit(1)
