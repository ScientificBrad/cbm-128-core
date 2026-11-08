#!/usr/bin/env python3
"""
Phase 5 Part 2: Inspect BASIC 7.0 Common RAM Template ($4251-$4308 -> $0380-$03D4),
Error Handler / TRAP / RESUME ($4A80-$4D3C),
NEWSTT / GONE / Statement & Prefix Dispatch ($4AC0-$4D2C, $513F-$5260),
Expression Evaluator FRMEVL / EVAL ($77B0-$7B50),
Variable Lookup PTRGET & Array Handling ($7B50-$8000),
and Floating-Point / String Engines ($8400-$9600).
"""
from pathlib import Path
import struct
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range, read_rom_slice

def dump_chrget_template():
    print("\n=== COMMON RAM TEMPLATE AT $4279-$42CE (COPIED TO $0380-$03D4) ===")
    # Note: $406A: LDX #$55; LDA $4278,X; STA $037F,X -> copies $4279..$42CD to $0380..$03D4!
    from generate_disassembly import OPCODES_6502, format_6502_operand
    raw = read_rom_slice(0x4279, 0x55)
    off = 0
    while off < len(raw):
        pc = 0x0380 + off
        rom_pc = 0x4279 + off
        op = raw[off]
        if op in OPCODES_6502 and off + OPCODES_6502[op][2] <= len(raw):
            mnem, mode, length = OPCODES_6502[op]
            inst_bytes = raw[off:off+length]
            op_str = format_6502_operand(mode, inst_bytes, pc)
            m_str = f"{mnem} {op_str}".strip()
        else:
            length = 1
            inst_bytes = raw[off:off+1]
            m_str = f".BYTE ${op:02X}"
        h_str = " ".join(f"{b:02X}" for b in inst_bytes)
        print(f"  RAM ${pc:04X} (ROM ${rom_pc:04X}): {h_str:<10} {m_str}")
        off += length

if __name__ == "__main__":
    disasm_range(0x4251, 0x4309, "VECTOR INIT ($4251) & BANK HELPERS ($42CE-$4308)")
    dump_chrget_template()
    disasm_range(0x4A80, 0x4D36, "ERROR HANDLER, NEWSTT, GONE & STATEMENT DISPATCH")
    disasm_range(0x513F, 0x5260, "LIST / DETOKENIZER (QPLOP) &WARM/CLEAR HELPERS")
