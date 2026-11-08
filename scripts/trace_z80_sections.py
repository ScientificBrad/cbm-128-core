#!/usr/bin/env python3
"""
Detailed trace of Z80 BIOS code and embedded 8502 slave routines in z80bios.bin.
"""
from pathlib import Path
import struct
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from generate_disassembly import decode_z80_inst, OPCODES_6502, format_6502_operand

Z80_ROM = (ROOT / "z80bios.bin").read_bytes()

def disasm_z80_range(start, end, inline_rst=True):
    print(f"\n=== Z80 DISASSEMBLY ${start:04X}-${end:04X} ===")
    offset = start
    while offset < end:
        res = decode_z80_inst(Z80_ROM, offset, end)
        if res is None:
            mnem, length = f".BYTE ${Z80_ROM[offset]:02X}", 1
        else:
            mnem, length = res
        raw = " ".join(f"{Z80_ROM[offset+i]:02X}" for i in range(length))
        print(f"  ${offset:04X}: {raw:<14} {mnem}")
        offset += length
        if inline_rst and Z80_ROM[offset - length] in (0xD7, 0xDF) and length == 1:
            if offset < end:
                param = Z80_ROM[offset]
                t1 = struct.unpack_from("<H", Z80_ROM, 0x0100 + param)[0] if 0x0100 + param + 1 < len(Z80_ROM) else 0
                t2 = struct.unpack_from("<H", Z80_ROM, 0x0100 + param + 2)[0] if 0x0100 + param + 3 < len(Z80_ROM) else 0
                print(f"  ${offset:04X}: {param:02X}             .BYTE ${param:02X} ; dispatch -> ${t1:04X} (40c) / ${t2:04X} (80c)")
                offset += 1

def disasm_6502_range(rom_start, rom_end, cpu_base):
    print(f"\n=== 8502 DISASSEMBLY ROM ${rom_start:04X}-${rom_end:04X} (CPU base ${cpu_base:04X}) ===")
    offset = rom_start
    while offset < rom_end:
        cpu_addr = cpu_base + (offset - rom_start)
        op = Z80_ROM[offset]
        if op in OPCODES_6502 and offset + OPCODES_6502[op][2] <= rom_end:
            mnem, mode, length = OPCODES_6502[op]
            raw_bytes = Z80_ROM[offset:offset+length]
            op_str = format_6502_operand(mode, raw_bytes, cpu_addr)
            full_mnem = f"{mnem} {op_str}".strip()
        else:
            full_mnem, length = f".BYTE ${op:02X}", 1
        raw = " ".join(f"{Z80_ROM[offset+i]:02X}" for i in range(length))
        print(f"  ROM ${offset:04X} (CPU ${cpu_addr:04X}): {raw:<10} {full_mnem}")
        offset += length

if __name__ == "__main__":
    disasm_z80_range(0x0000, 0x0030)
    disasm_z80_range(0x0038, 0x00EE)
    disasm_z80_range(0x017E, 0x0526)
