#!/usr/bin/env python3
"""
Disassemble 8502 KERNAL BOOT_CALL ($F890-$F9FB) and KERNAL_Z80_SWITCH ($E240-$E26B)
from kernal.318020-03.bin to verify the exact 8502 -> Z80 CP/M boot handoff.
"""
from pathlib import Path
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from generate_disassembly import OPCODES_6502, format_6502_operand

KERNAL = (ROOT / "kernal.318020-03.bin").read_bytes()

def disasm_kernal(start_addr, end_addr):
    print(f"\n=== 8502 KERNAL ${start_addr:04X}-${end_addr:04X} ===")
    pc = start_addr
    while pc < end_addr:
        off = pc - 0xC000
        op = KERNAL[off]
        if op in OPCODES_6502:
            mnem, mode, length = OPCODES_6502[op]
            raw_bytes = KERNAL[off:off+length]
            op_str = format_6502_operand(mode, raw_bytes, pc)
            full_mnem = f"{mnem} {op_str}".strip()
        else:
            full_mnem, length = f".BYTE ${op:02X}", 1
        raw = " ".join(f"{KERNAL[off+i]:02X}" for i in range(length))
        print(f"  ${pc:04X}: {raw:<10} {full_mnem}")
        pc += length

if __name__ == "__main__":
    disasm_kernal(0xE242, 0xE26B)
    disasm_kernal(0xF890, 0xF9C0)
