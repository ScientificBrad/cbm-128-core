#!/usr/bin/env python3
"""
Phase 5: Deep Reverse Engineering of Commodore BASIC 7.0
(`basic-4000.318018-02.bin` @ $4000-$7FFF and `basic-8000.318019-02.bin` @ $8000-$BFFF).
Traces:
1. Entry points ($4000-$4025, $8000-$800B, $B000-$B008) & Cold/Warm Startup ($4009-$4250, $A84D-$A900).
2. Tokenization (Crunch $4309-$4416) & Detokenization (List / Uncrunch $513F-$5246).
3. Keyword & Token tables ($4417-$4608, $4609-$46C8, $46C9-$4700).
4. Statement & Function Dispatch Tables ($4701-$484A) + Operator Precedence Table ($4828-$484A).
5. Error Message Table ($484B-$4A84) & Error Handler / TRAP / RESUME ($4A85-$4D60).
6. Main Interpreter Loop (`READY.`, `MAIN`, `NEWSTT`, `GONE` at $4D2C-$5060).
7. Expression Evaluator (`FRMEVL`, `EVAL`), Floating-Point & Integer Math ($7700-$8FFF).
8. Variable Lookup (`PTRGET`), Bank 1 Variable Storage (`INDFET`/`INDSTA`), Arrays (`DIM`), and Strings/Garbage Collection.
9. Structured Control Flow (`FOR`/`NEXT`, `IF`/`THEN`/`ELSE`, `DO`/`LOOP`/`WHILE`/`UNTIL`/`EXIT`, `GOSUB`/`RETURN`, `BEGIN`/`BEND`).
"""
from pathlib import Path
import struct
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from generate_disassembly import OPCODES_6502, format_6502_operand

B4 = (ROOT / "basic-4000.318018-02.bin").read_bytes()
B8 = (ROOT / "basic-8000.318019-02.bin").read_bytes()
KERNAL = (ROOT / "kernal.318020-03.bin").read_bytes()

def read_rom_byte(addr):
    if 0x4000 <= addr <= 0x7FFF:
        return B4[addr - 0x4000]
    if 0x8000 <= addr <= 0xBFFF:
        return B8[addr - 0x8000]
    if 0xC000 <= addr <= 0xFFFF:
        return KERNAL[addr - 0xC000]
    return 0

def read_rom_slice(addr, length):
    return bytes(read_rom_byte(addr + i) for i in range(length))

def disasm_range(start_addr, end_addr, title=""):
    print(f"\n=== {title} (${start_addr:04X}-${end_addr:04X}) ===")
    pc = start_addr
    while pc <= end_addr:
        op = read_rom_byte(pc)
        if op in OPCODES_6502:
            mnem, mode, length = OPCODES_6502[op]
            raw = read_rom_slice(pc, length)
            op_str = format_6502_operand(mode, raw, pc)
            full_mnem = f"{mnem} {op_str}".strip()
        else:
            length = 1
            raw = bytes([op])
            full_mnem = f".BYTE ${op:02X}"
        hex_str = " ".join(f"{b:02X}" for b in raw)
        print(f"  ${pc:04X}: {hex_str:<10} {full_mnem}")
        pc += length

if __name__ == "__main__":
    disasm_range(0x4000, 0x41BB, "BASIC 7.0 LOWER ENTRY & COLD/WARM START")
    disasm_range(0x8000, 0x8035, "BASIC 7.0 UPPER ENTRY VECTORS")
    disasm_range(0xA84D, 0xA8E0, "BASIC 7.0 UPPER INIT ($A84D)")
    disasm_range(0x42F0, 0x4416, "TOKENIZER (CRUNCH)")
    disasm_range(0x4D2C, 0x5060, "READY LOOP, LINE INSERTION, NEWSTT & GONE")
