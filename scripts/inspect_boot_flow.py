#!/usr/bin/env python3
"""
Extract exact disassemblies of critical C128 boot, Z80/8502 handoff, MMU setup,
RAMTAS, IOINIT, Screen Editor CINT/INIT80, IRQ/NMI, and BASIC Cold/Warm start flows.
"""
import os

WORKSPACE = r"D:\Emulation\C128"

def get_lines_for_range(asm_file, start_hex, end_hex):
    path = os.path.join(WORKSPACE, "disassembly", asm_file)
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()
    out = []
    in_range = False
    for line in lines:
        # check if `; $XXXX` is in line
        if f"; ${start_hex:04X}" in line:
            in_range = True
        if in_range:
            out.append(line.rstrip())
        if in_range and f"; ${end_hex:04X}" in line:
            # include a couple more lines if needed, then stop
            pass
        if in_range:
            # parse current address from `; $XXXX`
            idx = line.find("; $")
            if idx != -1:
                try:
                    addr = int(line[idx+3:idx+7], 16)
                    if addr > end_hex:
                        out.pop()
                        break
                except ValueError:
                    pass
    return "\n".join(out)

if __name__ == "__main__":
    print("=== Z80 RESET ($0000-$0075) ===")
    print(get_lines_for_range("z80bios_0000.asm", 0x0000, 0x0075))
    print("\n=== Z80 CP/M BOOT CHECK ($0076-$00FD) ===")
    print(get_lines_for_range("z80bios_0000.asm", 0x0076, 0x00FD))
    print("\n=== Z80 TO 8502 SWITCH ($0FE0-$0FFF or $0100-$0160) ===")
    print(get_lines_for_range("z80bios_0000.asm", 0x0100, 0x0160))
    print("\n=== KERNAL HARDWARE VECTORS & RESET/IRQ/NMI STUBS ($FF05-$FF46) ===")
    print(get_lines_for_range("kernal_c000_318020_03.asm", 0xFF05, 0xFF46))
    print("\n=== KERNAL RESET ROUTINE ($E000-$E092) ===")
    print(get_lines_for_range("kernal_c000_318020_03.asm", 0xE000, 0xE092))
    print("\n=== KERNAL RAMTAS & IOINIT ($E093-$E265) ===")
    print(get_lines_for_range("kernal_c000_318020_03.asm", 0xE093, 0xE265))
