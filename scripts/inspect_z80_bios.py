#!/usr/bin/env python3
"""
Phase 4: Deep Reverse Engineering of C128 Z80 BIOS (z80bios.bin / 252202-01)
Inspects internal tables, RST $10/$18 inline dispatch mechanisms, embedded 8502 slave routines,
and all Z80 functions in $0000-$0FFF.
"""
from pathlib import Path
import json
import struct

ROOT = Path(r"D:\Emulation\C128")
Z80_ROM = (ROOT / "z80bios.bin").read_bytes()

def dump_rst_vectors():
    print("=== RST AND ENTRY VECTORS ($0000-$00FF) ===")
    for addr in [0x0000, 0x0008, 0x0010, 0x0018, 0x0020, 0x0028, 0x0030, 0x0038, 0x0066, 0x00B4]:
        chunk = Z80_ROM[addr:addr+16]
        hex_str = " ".join(f"{b:02X}" for b in chunk)
        print(f"  ${addr:04X}: {hex_str}")

def dump_page_01_table():
    print("\n=== PAGE $01 DISPATCH TABLE ($0100-$018B) ===")
    for offset in range(0x0100, 0x018C, 2):
        target = struct.unpack_from("<H", Z80_ROM, offset)[0]
        idx = offset - 0x0100
        print(f"  Offset ${idx:02X} (${offset:04X}): -> ${target:04X}")

def find_rst10_rst18_calls():
    print("\n=== SCANNING FOR RST $10 (D7) AND RST $18 (DF) CALLS ===")
    for i in range(len(Z80_ROM) - 1):
        b = Z80_ROM[i]
        if b in (0xD7, 0xDF):
            param = Z80_ROM[i+1]
            if 0x0100 + param + 1 < len(Z80_ROM):
                target1 = struct.unpack_from("<H", Z80_ROM, 0x0100 + param)[0]
                target2 = struct.unpack_from("<H", Z80_ROM, 0x0100 + ((param + 2) & 0xFF))[0]
            else:
                target1 = target2 = 0
            kind = "RST $10" if b == 0xD7 else "RST $18"
            if param < 0x8C and (param % 2 == 0):
                print(f"  @${i:04X}: {kind} .byte ${param:02X} -> ${target1:04X} (or ${target2:04X} if 80-col)")

def dump_ascii_regions():
    print("\n=== ASCII STRINGS IN z80bios.bin ===")
    i = 0
    while i < len(Z80_ROM):
        if 32 <= Z80_ROM[i] <= 126:
            start = i
            while i < len(Z80_ROM) and (32 <= Z80_ROM[i] <= 126 or Z80_ROM[i] in (0x0A, 0x0D)):
                i += 1
            if i - start >= 4:
                s = Z80_ROM[start:i]
                print(f"  ${start:04X}-${i-1:04X} ({i-start}B): {s!r}")
        else:
            i += 1

def dump_high_memory():
    print("\n=== HIGH MEMORY ($0D00-$0FFF) HEX DUMP ===")
    for addr in range(0x0D00, 0x1000, 16):
        chunk = Z80_ROM[addr:addr+16]
        hex_str = " ".join(f"{b:02X}" for b in chunk)
        ascii_str = "".join(chr(b) if 32 <= b <= 126 else "." for b in chunk)
        print(f"  ${addr:04X}: {hex_str:<48} |{ascii_str}|")

if __name__ == "__main__":
    dump_rst_vectors()
    dump_page_01_table()
    find_rst10_rst18_calls()
    dump_ascii_regions()
    dump_high_memory()
