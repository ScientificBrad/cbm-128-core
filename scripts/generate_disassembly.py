#!/usr/bin/env python3
"""
Phase 2-3 Complete Disassembly & Byte-for-Byte Reconstructible Source Generator
for Commodore 128 Original 1985 Firmware Set:
- basic-4000.318018-02.bin (MOS 8502, $4000-$7FFF)
- basic-8000.318019-02.bin (MOS 8502, $8000-$BFFF)
- kernal.318020-03.bin     (MOS 8502 + Z80 BIOS at $D000-$DFFF, $C000-$FFFF)
- characters.390059-01.bin (8x8 Bitmap Character ROM, 8192 bytes)
- z80bios.bin              (Zilog Z80A, $0000-$0FFF)
"""

import os
import json

WORKSPACE = r"D:\Emulation\C128"

# Standard 6502/8502 Opcode Table: opcode -> (mnemonic, addressing_mode, length)
# Modes: imp, acc, imm, zp, zpx, zpy, ind, izx, izy, abs, abx, aby, rel
OPCODES_6502 = {
    0x00: ("BRK", "imp", 1), 0x01: ("ORA", "izx", 2), 0x05: ("ORA", "zp", 2),  0x06: ("ASL", "zp", 2),
    0x08: ("PHP", "imp", 1), 0x09: ("ORA", "imm", 2), 0x0A: ("ASL", "acc", 1), 0x0D: ("ORA", "abs", 3), 0x0E: ("ASL", "abs", 3),
    0x10: ("BPL", "rel", 2), 0x11: ("ORA", "izy", 2), 0x15: ("ORA", "zpx", 2), 0x16: ("ASL", "zpx", 2),
    0x18: ("CLC", "imp", 1), 0x19: ("ORA", "aby", 3), 0x1D: ("ORA", "abx", 3), 0x1E: ("ASL", "abx", 3),
    0x20: ("JSR", "abs", 3), 0x21: ("AND", "izx", 2), 0x24: ("BIT", "zp", 2),  0x25: ("AND", "zp", 2),  0x26: ("ROL", "zp", 2),
    0x28: ("PLP", "imp", 1), 0x29: ("AND", "imm", 2), 0x2A: ("ROL", "acc", 1), 0x2C: ("BIT", "abs", 3), 0x2D: ("AND", "abs", 3), 0x2E: ("ROL", "abs", 3),
    0x30: ("BMI", "rel", 2), 0x31: ("AND", "izy", 2), 0x35: ("AND", "zpx", 2), 0x36: ("ROL", "zpx", 2),
    0x38: ("SEC", "imp", 1), 0x39: ("AND", "aby", 3), 0x3D: ("AND", "abx", 3), 0x3E: ("ROL", "abx", 3),
    0x40: ("RTI", "imp", 1), 0x41: ("EOR", "izx", 2), 0x45: ("EOR", "zp", 2),  0x46: ("LSR", "zp", 2),
    0x48: ("PHA", "imp", 1), 0x49: ("EOR", "imm", 2), 0x4A: ("LSR", "acc", 1), 0x4C: ("JMP", "abs", 3), 0x4D: ("EOR", "abs", 3), 0x4E: ("LSR", "abs", 3),
    0x50: ("BVC", "rel", 2), 0x51: ("EOR", "izy", 2), 0x55: ("EOR", "zpx", 2), 0x56: ("LSR", "zpx", 2),
    0x58: ("CLI", "imp", 1), 0x59: ("EOR", "aby", 3), 0x5D: ("EOR", "abx", 3), 0x5E: ("LSR", "abx", 3),
    0x60: ("RTS", "imp", 1), 0x61: ("ADC", "izx", 2), 0x65: ("ADC", "zp", 2),  0x66: ("ROR", "zp", 2),
    0x68: ("PLA", "imp", 1), 0x69: ("ADC", "imm", 2), 0x6A: ("ROR", "acc", 1), 0x6C: ("JMP", "ind", 3), 0x6D: ("ADC", "abs", 3), 0x6E: ("ROR", "abs", 3),
    0x70: ("BVS", "rel", 2), 0x71: ("ADC", "izy", 2), 0x75: ("ADC", "zpx", 2), 0x76: ("ROR", "zpx", 2),
    0x78: ("SEI", "imp", 1), 0x79: ("ADC", "aby", 3), 0x7D: ("ADC", "abx", 3), 0x7E: ("ROR", "abx", 3),
    0x81: ("STA", "izx", 2), 0x84: ("STY", "zp", 2),  0x85: ("STA", "zp", 2),  0x86: ("STX", "zp", 2),
    0x88: ("DEY", "imp", 1), 0x8A: ("TXA", "imp", 1), 0x8C: ("STY", "abs", 3), 0x8D: ("STA", "abs", 3), 0x8E: ("STX", "abs", 3),
    0x90: ("BCC", "rel", 2), 0x91: ("STA", "izy", 2), 0x94: ("STY", "zpx", 2), 0x95: ("STA", "zpx", 2), 0x96: ("STX", "zpy", 2),
    0x98: ("TYA", "imp", 1), 0x99: ("STA", "aby", 3), 0x9A: ("TXS", "imp", 1), 0x9D: ("STA", "abx", 3),
    0xA0: ("LDY", "imm", 2), 0xA1: ("LDA", "izx", 2), 0xA2: ("LDX", "imm", 2), 0xA4: ("LDY", "zp", 2),  0xA5: ("LDA", "zp", 2),  0xA6: ("LDX", "zp", 2),
    0xA8: ("TAY", "imp", 1), 0xA9: ("LDA", "imm", 2), 0xAA: ("TAX", "imp", 1), 0xAC: ("LDY", "abs", 3), 0xAD: ("LDA", "abs", 3), 0xAE: ("LDX", "abs", 3),
    0xB0: ("BCS", "rel", 2), 0xB1: ("LDA", "izy", 2), 0xB4: ("LDY", "zpx", 2), 0xB5: ("LDA", "zpx", 2), 0xB6: ("LDX", "zpy", 2),
    0xB8: ("CLV", "imp", 1), 0xB9: ("LDA", "aby", 3), 0xBA: ("TSX", "imp", 1), 0xBC: ("LDY", "abx", 3), 0xBD: ("LDA", "abx", 3), 0xBE: ("LDX", "aby", 3),
    0xC0: ("CPY", "imm", 2), 0xC1: ("CMP", "izx", 2), 0xC4: ("CPY", "zp", 2),  0xC5: ("CMP", "zp", 2),  0xC6: ("DEC", "zp", 2),
    0xC8: ("INY", "imp", 1), 0xC9: ("CMP", "imm", 2), 0xCA: ("DEX", "imp", 1), 0xCC: ("CPY", "abs", 3), 0xCD: ("CMP", "abs", 3), 0xCE: ("DEC", "abs", 3),
    0xD0: ("BNE", "rel", 2), 0xD1: ("CMP", "izy", 2), 0xD5: ("CMP", "zpx", 2), 0xD6: ("DEC", "zpx", 2),
    0xD8: ("CLD", "imp", 1), 0xD9: ("CMP", "aby", 3), 0xDD: ("CMP", "abx", 3), 0xDE: ("DEC", "abx", 3),
    0xE0: ("CPX", "imm", 2), 0xE1: ("SBC", "izx", 2), 0xE4: ("CPX", "zp", 2),  0xE5: ("SBC", "zp", 2),  0xE6: ("INC", "zp", 2),
    0xE8: ("INX", "imp", 1), 0xE9: ("SBC", "imm", 2), 0xEA: ("NOP", "imp", 1), 0xEC: ("CPX", "abs", 3), 0xED: ("SBC", "abs", 3), 0xEE: ("INC", "abs", 3),
    0xF0: ("BEQ", "rel", 2), 0xF1: ("SBC", "izy", 2), 0xF5: ("SBC", "zpx", 2), 0xF6: ("INC", "zpx", 2),
    0xF8: ("SED", "imp", 1), 0xF9: ("SBC", "aby", 3), 0xFD: ("SBC", "abx", 3), 0xFE: ("INC", "abx", 3),
}

# Known Symbol Labels for C128 System Firmware & Hardware Registers
SYMBOLS_6502 = {
    0x0000: "D6510", 0x0001: "R6510",
    0x0314: "CINV",  0x0316: "CBINV", 0x0318: "NMINV",
    0x031A: "IOPEN", 0x031C: "ICLOSE", 0x031E: "ICHKIN", 0x0320: "ICKOUT",
    0x0322: "ICLRCH", 0x0324: "IBASIN", 0x0326: "IBSOUT", 0x0328: "ISTOP",
    0x032A: "IGETIN", 0x032C: "ICLALL", 0x032E: "EXMON", 0x0330: "ILOAD", 0x0332: "ISAVE",
    0x4000: "BASIC_COLD_ENTRY", 0x4003: "BASIC_WARM_ENTRY", 0x4006: "BASIC_IRQ_INIT_VEC",
    0x4009: "BASIC_WARM_START", 0x4023: "BASIC_COLD_START",
    0x41BC: "BASIC_BANNER_STR", 0x432B: "BASIC_CRUNCH",
    0x4417: "BASIC_TOKEN_TABLE_1", 0x4609: "BASIC_TOKEN_TABLE_CE", 0x46C9: "BASIC_TOKEN_TABLE_FE",
    0x4701: "BASIC_CMD_DISPATCH_TABLE", 0x484B: "BASIC_ERROR_MSG_TABLE",
    0x4A85: "BASIC_ERROR_HANDLER", 0x4D2D: "BASIC_READY_STR", 0x4D37: "BASIC_READY_LOOP",
    0x4D3C: "BASIC_ERROR_ENTRY", 0x4F93: "BASIC_NEWSTT_GONE",
    0x63F5: "BASIC_DESIGNER_CREDITS",
    0x8000: "BASIC_UPPER_BASE", 0xA84D: "BASIC_INIT_UPPER",
    0xB000: "MON_CALL_ENTRY", 0xB003: "MON_BRK_ENTRY", 0xB006: "MON_CMD_ENTRY",
    0xB009: "MON_BRK_HANDLER", 0xB021: "MON_INIT_HANDLER", 0xB0B2: "MON_MAIN_LOOP",
    0xC000: "ED_JCINT", 0xC003: "ED_JDISPLY", 0xC006: "ED_JLP2", 0xC009: "ED_JLOOP5",
    0xC00C: "ED_JPRT", 0xC00F: "ED_JSCRORG", 0xC012: "ED_JSCNKEY", 0xC015: "ED_JREPEAT",
    0xC018: "ED_JPLOT", 0xC01B: "ED_JCURSOR", 0xC01E: "ED_JESCAPE", 0xC021: "ED_JKEYSET",
    0xC024: "ED_JIRQ", 0xC027: "ED_JINIT80", 0xC02A: "ED_JSWAPPER", 0xC02D: "ED_JWINDOW",
    0xC07B: "ED_CINT_IMPL", 0xC194: "ED_IRQ_IMPL", 0xC234: "ED_LP2_IMPL", 0xC29B: "ED_LOOP5_IMPL",
    0xC55D: "ED_SCNKEY_IMPL", 0xC651: "ED_REPEAT_IMPL", 0xC72D: "ED_PRT_IMPL", 0xC9C1: "ED_ESCAPE_IMPL",
    0xCA1B: "ED_WINDOW_IMPL", 0xCC34: "ED_DISPLY_IMPL", 0xCC5B: "ED_SCRORG_IMPL", 0xCC6A: "ED_PLOT_IMPL",
    0xCCA2: "ED_KEYSET_IMPL", 0xCD2E: "ED_SWAPPER_IMPL", 0xCD57: "ED_CURSOR_IMPL", 0xCE0C: "ED_INIT80_IMPL",
    0xD000: "VIC_SP0X", 0xD011: "VIC_SCROLY", 0xD012: "VIC_RASTER", 0xD015: "VIC_SPENA",
    0xD016: "VIC_SCROLX", 0xD018: "VIC_VMCSB", 0xD019: "VIC_VICIRQ", 0xD01A: "VIC_IRQMSK",
    0xD020: "VIC_EXTCOL", 0xD021: "VIC_BGCOL0", 0xD02F: "VIC_KEYREG", 0xD030: "VIC_CLK2MHZ",
    0xD400: "SID_BASE", 0xD500: "MMU_CR", 0xD501: "MMU_PCRA", 0xD502: "MMU_PCRB",
    0xD503: "MMU_PCRC", 0xD504: "MMU_PCRD", 0xD505: "MMU_MCR", 0xD506: "MMU_RCR",
    0xD507: "MMU_P0L", 0xD508: "MMU_P0H", 0xD509: "MMU_P1L", 0xD50A: "MMU_P1H", 0xD50B: "MMU_VR",
    0xD600: "VDC_ADDR_STATUS", 0xD601: "VDC_DATA",
    0xDC00: "CIA1_PRA", 0xDC01: "CIA1_PRB", 0xDC02: "CIA1_DDRA", 0xDC03: "CIA1_DDRB",
    0xDC0D: "CIA1_ICR", 0xDC0E: "CIA1_CRA", 0xDC0F: "CIA1_CRB",
    0xDD00: "CIA2_PRA", 0xDD01: "CIA2_PRB", 0xDD02: "CIA2_DDRA", 0xDD03: "CIA2_DDRB",
    0xDD0D: "CIA2_ICR",
    0xE000: "KERNAL_RESET_START", 0xE056: "KERNAL_RESTOR", 0xE05B: "KERNAL_VECTOR",
    0xE093: "KERNAL_RAMTAS", 0xE109: "KERNAL_IOINIT", 0xE242: "KERNAL_Z80_SWITCH",
    0xE24B: "KERNAL_C64MODE", 0xE33B: "KERNAL_TALK", 0xE33E: "KERNAL_LISTEN",
    0xE43E: "KERNAL_ACPTR", 0xE4D2: "KERNAL_SECOND", 0xE4E0: "KERNAL_TKSA",
    0xE503: "KERNAL_CIOUT", 0xE515: "KERNAL_UNTLK", 0xE526: "KERNAL_UNLSN",
    0xE5FB: "KERNAL_SPIN_SPOUT", 0xF23D: "KERNAL_CLOSE_ALL", 0xF265: "KERNAL_LOAD",
    0xF53E: "KERNAL_SAVE", 0xF5F8: "KERNAL_UDTIM", 0xF65E: "KERNAL_RDTIM",
    0xF665: "KERNAL_SETTIM", 0xF731: "KERNAL_SETNAM", 0xF738: "KERNAL_SETLFS",
    0xF73F: "KERNAL_SETBNK", 0xF744: "KERNAL_READST", 0xF75C: "KERNAL_SETMSG",
    0xF75F: "KERNAL_SETTMO", 0xF763: "KERNAL_MEMTOP", 0xF772: "KERNAL_MEMBOT",
    0xF781: "KERNAL_IOBASE", 0xF786: "KERNAL_LKUPSA", 0xF79D: "KERNAL_LKUPLA",
    0xF7A5: "KERNAL_DMA_CALL", 0xF7D0: "KERNAL_INDFET", 0xF7DA: "KERNAL_INDSTA",
    0xF7E3: "KERNAL_INDCMP", 0xF7EC: "KERNAL_GETCFG", 0xF867: "KERNAL_PHOENIX",
    0xF890: "KERNAL_BOOT_CALL", 0xFA17: "KERNAL_PRIMM",
    0xFF00: "MMU_CR_TOP", 0xFF01: "MMU_LCRA_TOP", 0xFF02: "MMU_LCRB_TOP",
    0xFF03: "MMU_LCRC_TOP", 0xFF04: "MMU_LCRD_TOP",
    0xFF05: "HW_NMI_ENTRY", 0xFF17: "HW_IRQ_ENTRY", 0xFF3D: "HW_RESET_ENTRY",
    0xFF47: "J_SPIN_SPOUT", 0xFF4A: "J_CLOSE_ALL", 0xFF4D: "J_C64MODE", 0xFF50: "J_DMA_CALL",
    0xFF53: "J_BOOT_CALL", 0xFF56: "J_PHOENIX", 0xFF59: "J_LKUPLA", 0xFF5C: "J_LKUPSA",
    0xFF5F: "J_SWAPPER", 0xFF62: "J_DLCHR", 0xFF65: "J_PFKEY", 0xFF68: "J_SETBNK",
    0xFF6B: "J_GETCFG", 0xFF6E: "J_JSRFAR", 0xFF71: "J_JMPFAR", 0xFF74: "J_INDFET",
    0xFF77: "J_INDSTA", 0xFF7A: "J_INDCMP", 0xFF7D: "J_PRIMM",
    0xFF81: "J_CINT", 0xFF84: "J_IOINIT", 0xFF87: "J_RAMTAS", 0xFF8A: "J_RESTOR",
    0xFF8D: "J_VECTOR", 0xFF90: "J_SETMSG", 0xFF93: "J_SECOND", 0xFF96: "J_TKSA",
    0xFF99: "J_MEMTOP", 0xFF9C: "J_MEMBOT", 0xFF9F: "J_SCNKEY", 0xFFA2: "J_SETTMO",
    0xFFA5: "J_ACPTR", 0xFFA8: "J_CIOUT", 0xFFAB: "J_UNTLK", 0xFFAE: "J_UNLSN",
    0xFFB1: "J_LISTEN", 0xFFB4: "J_TALK", 0xFFB7: "J_READST", 0xFFBA: "J_SETLFS",
    0xFFBD: "J_SETNAM", 0xFFC0: "J_OPEN", 0xFFC3: "J_CLOSE", 0xFFC6: "J_CHKIN",
    0xFFC9: "J_CHKOUT", 0xFFCC: "J_CLRCH", 0xFFCF: "J_BASIN", 0xFFD2: "J_BSOUT",
    0xFFD5: "J_LOAD", 0xFFD8: "J_SAVE", 0xFFDB: "J_SETTIM", 0xFFDE: "J_RDTIM",
    0xFFE1: "J_STOP", 0xFFE4: "J_GETIN", 0xFFE7: "J_CLALL", 0xFFEA: "J_UDTIM",
    0xFFED: "J_SCREEN", 0xFFF0: "J_PLOT", 0xFFF3: "J_IOBASE",
    0xFFFA: "HW_VEC_NMI", 0xFFFC: "HW_VEC_RESET", 0xFFFE: "HW_VEC_IRQ"
}

def format_6502_operand(mode, raw_bytes, pc):
    if mode == "imp":
        return ""
    if mode == "acc":
        return "A"
    if mode == "imm":
        return f"#${raw_bytes[1]:02X}"
    if mode == "zp":
        return f"${raw_bytes[1]:02X}"
    if mode == "zpx":
        return f"${raw_bytes[1]:02X},X"
    if mode == "zpy":
        return f"${raw_bytes[1]:02X},Y"
    if mode == "izx":
        return f"(${raw_bytes[1]:02X},X)"
    if mode == "izy":
        return f"(${raw_bytes[1]:02X}),Y"
    if mode == "rel":
        rel = raw_bytes[1]
        if rel >= 0x80:
            rel -= 0x100
        dest = (pc + 2 + rel) & 0xFFFF
        sym = SYMBOLS_6502.get(dest)
        return f"${dest:04X}" + (f" ; {sym}" if sym else "")
    val16 = raw_bytes[1] | (raw_bytes[2] << 8)
    sym = SYMBOLS_6502.get(val16)
    comment = f" ; {sym}" if sym else ""
    if mode == "abs":
        return f"${val16:04X}{comment}"
    if mode == "abx":
        return f"${val16:04X},X{comment}"
    if mode == "aby":
        return f"${val16:04X},Y{comment}"
    if mode == "ind":
        return f"(${val16:04X}){comment}"
    return ""

def disassemble_8502_region(data, base_addr, data_ranges, title, rom_filename):
    """
    Produces a complete, byte-accurate assembly listing for a 6502/8502 ROM image.
    `data_ranges` is a list of (start_addr, end_addr_inclusive, description, style)
    where style is 'byte', 'word', 'ascii', or 'padding'.
    """
    range_map = {}
    for s, e, desc, style in data_ranges:
        for a in range(s, e + 1):
            range_map[a] = (s, e, desc, style)

    lines = [
        f"; =============================================================================",
        f"; {title}",
        f"; Source ROM: {rom_filename} ({len(data)} bytes, ${base_addr:04X}-${base_addr+len(data)-1:04X})",
        f"; Architecture: MOS 8502",
        f"; Generated by cbm-128-core deterministic reconstructor",
        f"; =============================================================================",
        f"    .ORG ${base_addr:04X}",
        ""
    ]

    off = 0
    n = len(data)
    while off < n:
        pc = base_addr + off
        if pc in SYMBOLS_6502:
            lines.append(f"{SYMBOLS_6502[pc]}:")

        if pc in range_map:
            s, e, desc, style = range_map[pc]
            if pc == s:
                lines.append(f"; --- {desc} (${s:04X}-${e:04X}) ---")
            chunk_end_off = min(n, (e - base_addr) + 1)
            # Emit 8 bytes per .BYTE line for clean readability and exact reconstruction
            while off < chunk_end_off:
                cur_pc = base_addr + off
                if cur_pc != pc and cur_pc in SYMBOLS_6502:
                    lines.append(f"{SYMBOLS_6502[cur_pc]}:")
                row_len = min(8, chunk_end_off - off)
                row = data[off:off+row_len]
                hex_bytes = ", ".join(f"${b:02X}" for b in row)
                ascii_preview = "".join(chr(b) if 0x20 <= b <= 0x7E else "." for b in row)
                lines.append(f"    .BYTE {hex_bytes:38s} ; ${cur_pc:04X} |{ascii_preview}|")
                off += row_len
            continue

        op = data[off]
        if op in OPCODES_6502:
            mnem, mode, length = OPCODES_6502[op]
            # Check if instruction crosses into a known data range or end of ROM
            if off + length <= n and not any((pc + k) in range_map for k in range(1, length)):
                # Also note: if mode is abs/abx/aby and value < $0100, standard 6502 assemblers might assemble as ZP unless forced or emitted with explicit bytes if needed, OR our reconstructor supports `.ABS` or `.BYTE` or exact addressing mode!
                raw = data[off:off+length]
                operand_str = format_6502_operand(mode, raw, pc)
                raw_hex = " ".join(f"{b:02X}" for b in raw)
                # If an absolute addressing mode targets `$0000-$00FF`, mark with `.ABS` suffix so assembler knows 3-byte absolute vs 2-byte ZP
                mnem_out = mnem
                if mode in ("abs", "abx", "aby") and (raw[1] | (raw[2] << 8)) < 0x100:
                    mnem_out = f"{mnem}.W"
                if operand_str:
                    # Separate inline comment if present
                    if " ; " in operand_str:
                        op_part, sym_part = operand_str.split(" ; ", 1)
                        lines.append(f"    {mnem_out:5s} {op_part:18s} ; ${pc:04X}: {raw_hex:8s} ({sym_part})")
                    else:
                        lines.append(f"    {mnem_out:5s} {operand_str:18s} ; ${pc:04X}: {raw_hex:8s}")
                else:
                    lines.append(f"    {mnem_out:24s} ; ${pc:04X}: {raw_hex:8s}")
                off += length
                continue

        # Fallback for undocumented/data byte
        b = data[off]
        lines.append(f"    .BYTE ${b:02X}                                ; ${pc:04X}: {b:02X}")
        off += 1

    return "\n".join(lines) + "\n"

# Basic Z80 Disassembler for Z80 BIOS ($0000-$0FFF)
Z80_REG8 = ["B", "C", "D", "E", "H", "L", "(HL)", "A"]
Z80_REG16 = ["BC", "DE", "HL", "SP"]
Z80_REG16_AF = ["BC", "DE", "HL", "AF"]
Z80_COND = ["NZ", "Z", "NC", "C", "PO", "PE", "P", "M"]
Z80_ALU = ["ADD A,", "ADC A,", "SUB ", "SBC A,", "AND ", "XOR ", "OR ", "CP "]

def decode_z80_inst(data, off, max_off):
    """Returns (mnemonic_str, length) or None if data/incomplete."""
    rem = max_off - off
    if rem <= 0:
        return None
    b0 = data[off]
    # Simple 1-byte opcodes
    SIMPLE_1 = {
        0x00: "NOP", 0x02: "LD (BC),A", 0x07: "RLCA", 0x08: "EX AF,AF'", 0x0A: "LD A,(BC)", 0x0F: "RRCA",
        0x12: "LD (DE),A", 0x17: "RLA", 0x1A: "LD A,(DE)", 0x1F: "RRA",
        0x27: "DAA", 0x2F: "CPL", 0x37: "SCF", 0x3F: "CCF",
        0x76: "HALT", 0xC9: "RET", 0xD9: "EXX", 0xE3: "EX (SP),HL", 0xE9: "JP (HL)",
        0xEB: "EX DE,HL", 0xF3: "DI", 0xF9: "LD SP,HL", 0xFB: "EI"
    }
    if b0 in SIMPLE_1:
        return (SIMPLE_1[b0], 1)
    if 0x40 <= b0 <= 0x7F and b0 != 0x76:
        dst = Z80_REG8[(b0 >> 3) & 7]
        src = Z80_REG8[b0 & 7]
        return (f"LD {dst},{src}", 1)
    if 0x80 <= b0 <= 0xBF:
        alu = Z80_ALU[(b0 >> 3) & 7]
        src = Z80_REG8[b0 & 7]
        return (f"{alu}{src}", 1)
    if (b0 & 0xC7) == 0x04:
        return (f"INC {Z80_REG8[(b0 >> 3) & 7]}", 1)
    if (b0 & 0xC7) == 0x05:
        return (f"DEC {Z80_REG8[(b0 >> 3) & 7]}", 1)
    if (b0 & 0xCF) == 0x03:
        return (f"INC {Z80_REG16[(b0 >> 4) & 3]}", 1)
    if (b0 & 0xCF) == 0x0B:
        return (f"DEC {Z80_REG16[(b0 >> 4) & 3]}", 1)
    if (b0 & 0xCF) == 0x09:
        return (f"ADD HL,{Z80_REG16[(b0 >> 4) & 3]}", 1)
    if (b0 & 0xCF) == 0xC5:
        return (f"PUSH {Z80_REG16_AF[(b0 >> 4) & 3]}", 1)
    if (b0 & 0xCF) == 0xC1:
        return (f"POP {Z80_REG16_AF[(b0 >> 4) & 3]}", 1)
    if (b0 & 0xC7) == 0xC0:
        return (f"RET {Z80_COND[(b0 >> 3) & 7]}", 1)
    if (b0 & 0xC7) == 0xC7:
        return (f"RST ${b0 & 0x38:02X}", 1)

    # 2-byte opcodes
    if (b0 & 0xC7) == 0x06 and rem >= 2:
        return (f"LD {Z80_REG8[(b0 >> 3) & 7]},${data[off+1]:02X}", 2)
    if (b0 & 0xC7) == 0xC6 and rem >= 2:
        return (f"{Z80_ALU[(b0 >> 3) & 7]}${data[off+1]:02X}", 2)
    if b0 == 0xD3 and rem >= 2:
        return (f"OUT (${data[off+1]:02X}),A", 2)
    if b0 == 0xDB and rem >= 2:
        return (f"IN A,(${data[off+1]:02X})", 2)
    if b0 in (0x10, 0x18, 0x20, 0x28, 0x30, 0x38) and rem >= 2:
        rel = data[off+1]
        if rel >= 0x80:
            rel -= 0x100
        dest = (off + 2 + rel) & 0xFFFF
        names = {0x10: "DJNZ", 0x18: "JR", 0x20: "JR NZ,", 0x28: "JR Z,", 0x30: "JR NC,", 0x38: "JR C,"}
        sep = " " if names[b0] in ("DJNZ", "JR") else ""
        return (f"{names[b0]}{sep}${dest:04X}", 2)

    # 3-byte opcodes
    if (b0 & 0xCF) == 0x01 and rem >= 3:
        val16 = data[off+1] | (data[off+2] << 8)
        return (f"LD {Z80_REG16[(b0 >> 4) & 3]},${val16:04X}", 3)
    if b0 in (0x22, 0x2A, 0x32, 0x3A, 0xC3, 0xCD) and rem >= 3:
        val16 = data[off+1] | (data[off+2] << 8)
        m = {
            0x22: f"LD (${val16:04X}),HL",
            0x2A: f"LD HL,(${val16:04X})",
            0x32: f"LD (${val16:04X}),A",
            0x3A: f"LD A,(${val16:04X})",
            0xC3: f"JP ${val16:04X}",
            0xCD: f"CALL ${val16:04X}",
        }
        return (m[b0], 3)
    if (b0 & 0xC7) == 0xC2 and rem >= 3:
        val16 = data[off+1] | (data[off+2] << 8)
        return (f"JP {Z80_COND[(b0 >> 3) & 7]},${val16:04X}", 3)
    if (b0 & 0xC7) == 0xC4 and rem >= 3:
        val16 = data[off+1] | (data[off+2] << 8)
        return (f"CALL {Z80_COND[(b0 >> 3) & 7]},${val16:04X}", 3)

    # ED prefix
    if b0 == 0xED and rem >= 2:
        b1 = data[off+1]
        ed_1 = {
            0x44: "NEG", 0x45: "RETN", 0x46: "IM 0", 0x47: "LD I,A",
            0x4D: "RETI", 0x4F: "LD R,A", 0x56: "IM 1", 0x57: "LD A,I",
            0x5E: "IM 2", 0x5F: "LD A,R", 0x67: "RRD", 0x6F: "RLD",
            0xA0: "LDI", 0xA1: "CPI", 0xA2: "INI", 0xA3: "OUTI",
            0xA8: "LDD", 0xA9: "CPD", 0xAA: "IND", 0xAB: "OUTD",
            0xB0: "LDIR", 0xB1: "CPIR", 0xB2: "INIR", 0xB3: "OTIR",
            0xB8: "LDDR", 0xB9: "CPDR", 0xBA: "INDR", 0xBB: "OTDR"
        }
        if b1 in ed_1:
            return (ed_1[b1], 2)
        if (b1 & 0xC7) == 0x40:
            return (f"IN {Z80_REG8[(b1 >> 3) & 7]},(C)", 2)
        if (b1 & 0xC7) == 0x41:
            return (f"OUT (C),{Z80_REG8[(b1 >> 3) & 7]}", 2)
        if (b1 & 0xCF) == 0x42:
            return (f"SBC HL,{Z80_REG16[(b1 >> 4) & 3]}", 2)
        if (b1 & 0xCF) == 0x4A:
            return (f"ADC HL,{Z80_REG16[(b1 >> 4) & 3]}", 2)
        if (b1 & 0xCF) == 0x43 and rem >= 4:
            val16 = data[off+2] | (data[off+3] << 8)
            return (f"LD (${val16:04X}),{Z80_REG16[(b1 >> 4) & 3]}", 4)
        if (b1 & 0xCF) == 0x4B and rem >= 4:
            val16 = data[off+2] | (data[off+3] << 8)
            return (f"LD {Z80_REG16[(b1 >> 4) & 3]},(${val16:04X})", 4)

    # CB prefix
    if b0 == 0xCB and rem >= 2:
        b1 = data[off+1]
        reg = Z80_REG8[b1 & 7]
        bit = (b1 >> 3) & 7
        top = b1 >> 6
        if top == 0:
            shifts = ["RLC", "RRC", "RL", "RR", "SLA", "SRA", "SLL", "SRL"]
            return (f"{shifts[bit]} {reg}", 2)
        elif top == 1:
            return (f"BIT {bit},{reg}", 2)
        elif top == 2:
            return (f"RES {bit},{reg}", 2)
        else:
            return (f"SET {bit},{reg}", 2)

    return None

def disassemble_z80_bios(data):
    data_ranges = [
        (0x0030, 0x0037, "Z80 BIOS Release Date Stamp ('05/12/85')"),
        (0x00EE, 0x00F8, "CP/M 3.0 System Filename ('CPM+    SYS')"),
        (0x01F6, 0x0206, "Boot Banner ('BOOTING CP/M PLUS')"),
        (0x0254, 0x02BE, "CP/M 3.0 Loader Section Strings"),
        (0x0485, 0x0518, "CP/M 3.0 Loader Error Messages"),
        (0x0FC0, 0x0FFF, "GCR Disk Sector Interleave Tables")
    ]
    rmap = {}
    for s, e, desc in data_ranges:
        for a in range(s, e + 1):
            rmap[a] = (s, e, desc)

    lines = [
        "; =============================================================================",
        "; Commodore 128 Z80 BIOS Disassembly ($0000-$0FFF Z80 / $D000-$DFFF U35)",
        "; Source ROM: z80bios.bin / kernal.318020-03.bin [0x1000-0x1FFF] (4096 bytes)",
        "; Architecture: Zilog Z80A",
        "; =============================================================================",
        "    .ARCH Z80",
        "    .ORG $0000",
        ""
    ]
    off = 0
    n = len(data)
    while off < n:
        if off in (0x0000, 0x0008, 0x0010, 0x0018, 0x0020, 0x0028, 0x0030, 0x0038, 0x0066):
            lines.append(f"Z80_VEC_{off:04X}:")
        if off in rmap:
            s, e, desc = rmap[off]
            if off == s:
                lines.append(f"; --- {desc} (${s:04X}-${e:04X}) ---")
            end_off = min(n, e + 1)
            while off < end_off:
                rlen = min(8, end_off - off)
                row = data[off:off+rlen]
                hex_b = ", ".join(f"${b:02X}" for b in row)
                asc = "".join(chr(b) if 0x20 <= b <= 0x7E else "." for b in row)
                lines.append(f"    .BYTE {hex_b:38s} ; ${off:04X} |{asc}|")
                off += rlen
            continue

        decoded = decode_z80_inst(data, off, n)
        if decoded:
            mnem, length = decoded
            if not any((off + k) in rmap for k in range(1, length)):
                raw = data[off:off+length]
                raw_hex = " ".join(f"{b:02X}" for b in raw)
                # Also include .BYTE directive in comment or emit exact reconstructible bytes
                lines.append(f"    {mnem:24s} ; ${off:04X}: {raw_hex}")
                off += length
                continue

        b = data[off]
        lines.append(f"    .BYTE ${b:02X}                                ; ${off:04X}: {b:02X}")
        off += 1

    return "\n".join(lines) + "\n"

def generate_character_rom_source(data):
    lines = [
        "; =============================================================================",
        "; Commodore 128 Character Generator ROM Source (390059-01, 8192 bytes)",
        "; Socket U18: $0000-$0FFF (C64 Font Set 1 & 2), $1000-$1FFF (C128 Font Set 1 & 2)",
        "; =============================================================================",
        "    .ORG $0000",
        ""
    ]
    quarters = [
        (0x0000, "C64 Mode Set 1: Uppercase + PETSCII Graphics"),
        (0x0800, "C64 Mode Set 2: Lowercase + Uppercase"),
        (0x1000, "C128 Mode Set 1: Uppercase + PETSCII Graphics"),
        (0x1800, "C128 Mode Set 2: Lowercase + Uppercase (Redesigned C128 Glyphs)")
    ]
    for q_start, q_title in quarters:
        lines.append(f"; === {q_title} (${q_start:04X}-${q_start+0x07FF:04X}) ===")
        for ch_idx in range(256):
            off = q_start + ch_idx * 8
            row = data[off:off+8]
            hex_b = ", ".join(f"${b:02X}" for b in row)
            lines.append(f"    .BYTE {hex_b} ; ${off:04X} Glyph ${ch_idx:02X} ({ch_idx:3d})")
        lines.append("")
    return "\n".join(lines) + "\n"

def main():
    os.makedirs(os.path.join(WORKSPACE, "disassembly"), exist_ok=True)
    os.makedirs(os.path.join(WORKSPACE, "reconstruction", "src"), exist_ok=True)

    b4 = open(os.path.join(WORKSPACE, "basic-4000.318018-02.bin"), "rb").read()
    b8 = open(os.path.join(WORKSPACE, "basic-8000.318019-02.bin"), "rb").read()
    kn = open(os.path.join(WORKSPACE, "kernal.318020-03.bin"), "rb").read()
    ch = open(os.path.join(WORKSPACE, "characters.390059-01.bin"), "rb").read()
    z8 = open(os.path.join(WORKSPACE, "z80bios.bin"), "rb").read()

    b4_ranges = [
        (0x41BC, 0x424F, "BASIC 7.0 Startup Sign-On Banner", "ascii"),
        (0x4417, 0x4608, "Primary Keyword Token Table (126 Tokens)", "ascii"),
        (0x4609, 0x46C8, "Extended 0xCE Keyword Token Table (37 Tokens)", "ascii"),
        (0x46C9, 0x4700, "Extended 0xFE Function Token Table (9 Tokens)", "ascii"),
        (0x4701, 0x484A, "Keyword & Operator Dispatch Address Tables", "word"),
        (0x484B, 0x4A84, "BASIC 7.0 Error Message Tables (41 Messages)", "ascii"),
        (0x4D2D, 0x4D36, "READY. Prompt String", "ascii"),
        (0x63F5, 0x6409, "Embedded Designer Credits (FRED B / TERRY R / MIKE I)", "ascii"),
        (0x7E82, 0x7FFD, "Unused ROM Padding (0xFF)", "padding"),
        (0x7FFE, 0x7FFF, "ROM Revision and Checksum Trailer", "byte")
    ]
    b4_asm = disassemble_8502_region(b4, 0x4000, b4_ranges, "Commodore 128 BASIC 7.0 Lower ROM (318018-02)", "basic-4000.318018-02.bin")

    b8_ranges = [
        (0xAA6E, 0xAE62, "Unused ROM Padding Block 1 (0xFF)", "padding"),
        (0xAFA8, 0xAFFF, "Unused ROM Padding Block 2 (0xFF)", "padding"),
        (0xB053, 0xB06C, "ML Monitor Register Header String", "ascii"),
        (0xB0E6, 0xB11F, "ML Monitor Command & Dispatch Tables", "byte"),
        (0xB6B0, 0xB8FF, "ML Monitor 8502 Opcode Mode & Packed Mnemonic Tables", "byte"),
        (0xBB72, 0xBFFD, "Unused ROM Padding Block 3 (0xFF)", "padding"),
        (0xBFFE, 0xBFFF, "ROM Revision and Checksum Trailer", "byte")
    ]
    b8_asm = disassemble_8502_region(b8, 0x8000, b8_ranges, "Commodore 128 BASIC 7.0 Upper ROM & ML Monitor (318019-02)", "basic-8000.318019-02.bin")

    kn_ranges = [
        (0xC030, 0xC065, "Screen Editor Line Address Tables", "byte"),
        (0xCE5C, 0xCEF4, "8563 VDC Register Init Table & Function Key Strings", "byte"),
        (0xCEF5, 0xCFFD, "Screen Editor Unused Padding (0xFF)", "padding"),
        (0xCFFE, 0xCFFF, "Screen Editor Revision and Checksum Trailer", "byte"),
        (0xD000, 0xDFFF, "Embedded Z80 BIOS Image (Mapped to Z80 $0000-$0FFF)", "byte"),
        (0xF6AD, 0xF718, "KERNAL Direct I/O & Tape Status Messages", "ascii"),
        (0xFA80, 0xFC3A, "KERNAL Keyboard Matrix Decode Tables", "byte"),
        (0xFC3B, 0xFF04, "KERNAL Unused Padding & $FF00-$FF04 MMU Shadow", "padding"),
        (0xFF80, 0xFF80, "KERNAL Release Checksum / Revision Byte", "byte"),
        (0xFFF6, 0xFFFF, "MOS 8502 System & Hardware Interrupt Vectors", "word")
    ]
    kn_asm = disassemble_8502_region(kn, 0xC000, kn_ranges, "Commodore 128 System ROM: Editor, Z80 BIOS & KERNAL (318020-03)", "kernal.318020-03.bin")

    z8_asm = disassemble_z80_bios(z8)
    ch_asm = generate_character_rom_source(ch)

    files_out = [
        ("basic_4000_318018_02.asm", b4_asm),
        ("basic_8000_318019_02.asm", b8_asm),
        ("kernal_c000_318020_03.asm", kn_asm),
        ("z80bios_0000.asm", z8_asm),
        ("characters_390059_01.asm", ch_asm)
    ]

    for fname, content in files_out:
        with open(os.path.join(WORKSPACE, "disassembly", fname), "w", encoding="utf-8") as f:
            f.write(content)
        with open(os.path.join(WORKSPACE, "reconstruction", "src", fname), "w", encoding="utf-8") as f:
            f.write(content)

    print("Disassembly and reconstruction sources generated successfully.")
    for fname, content in files_out:
        print(f"  {fname:30s}: {content.count(chr(10)):6d} lines")

if __name__ == "__main__":
    main()
