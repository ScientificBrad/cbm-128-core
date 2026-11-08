#!/usr/bin/env python3
"""
Phase 1.3 & 1.4 Deep Structural Segmentation & Evidence Extractor.
Maps exact internal boundaries, jump tables, interrupt vectors, token tables,
strings, padding blocks, and character font structures across all 5 ROMs.
"""

import os
import json

WORKSPACE = r"D:\Emulation\C128"

def load_rom(name):
    with open(os.path.join(WORKSPACE, name), "rb") as f:
        return f.read()

def word_le(data, offset):
    return data[offset] | (data[offset + 1] << 8)

def decode_jmp_table(data, base_addr, start_addr, end_addr):
    entries = []
    for addr in range(start_addr, end_addr, 3):
        off = addr - base_addr
        opcode = data[off]
        target = word_le(data, off + 1)
        if opcode == 0x4C:  # JMP abs
            entries.append({
                "vector_addr": f"${addr:04X}",
                "file_offset": f"0x{off:04X}",
                "instruction": f"JMP ${target:04X}",
                "target_addr": f"${target:04X}"
            })
        elif opcode == 0x6C:  # JMP (ind)
            entries.append({
                "vector_addr": f"${addr:04X}",
                "file_offset": f"0x{off:04X}",
                "instruction": f"JMP (${target:04X})",
                "target_addr": f"(${target:04X})"
            })
        else:
            entries.append({
                "vector_addr": f"${addr:04X}",
                "file_offset": f"0x{off:04X}",
                "instruction": f"RAW {opcode:02X} {data[off+1]:02X} {data[off+2]:02X}",
                "target_addr": None
            })
    return entries

def main():
    b4 = load_rom("basic-4000.318018-02.bin")
    b8 = load_rom("basic-8000.318019-02.bin")
    kn = load_rom("kernal.318020-03.bin")
    ch = load_rom("characters.390059-01.bin")
    z8 = load_rom("z80bios.bin")

    results = {}

    # 1. Inspect BASIC Lower ($4000-$7FFF)
    # Check entry vectors at $4000
    b4_vectors = decode_jmp_table(b4, 0x4000, 0x4000, 0x4009)
    # Find strings in b4
    # Let's check banner / copyright / error messages / tokens in b4
    results["basic_lower_4000"] = {
        "entry_vectors_4000": b4_vectors,
        "first_64_bytes_hex": b4[:64].hex(),
        "last_64_bytes_hex": b4[-64:].hex()
    }

    # Find all padding runs >= 16 bytes across all ROMs
    padding_map = {}
    for name, blob, base in [
        ("basic-4000.318018-02.bin", b4, 0x4000),
        ("basic-8000.318019-02.bin", b8, 0x8000),
        ("kernal.318020-03.bin", kn, 0xC000),
        ("characters.390059-01.bin", ch, 0x0000),
        ("z80bios.bin", z8, 0x0000)
    ]:
        runs = []
        i = 0
        n = len(blob)
        while i < n:
            b = blob[i]
            j = i + 1
            while j < n and blob[j] == b:
                j += 1
            if j - i >= 16:
                runs.append({
                    "byte": f"0x{b:02X}",
                    "file_offset_start": f"0x{i:04X}",
                    "file_offset_end": f"0x{j-1:04X}",
                    "cpu_start": f"${base+i:04X}",
                    "cpu_end": f"${base+j-1:04X}",
                    "length": j - i
                })
            i = j
        padding_map[name] = runs
    results["padding_runs_min16"] = padding_map

    # 2. Inspect BASIC Upper ($8000-$BFFF)
    # Locate Machine Language Monitor ($B000-$BFFF usually)
    # Check $B000 jump table or entry points
    b8_b000_jmp = decode_jmp_table(b8, 0x8000, 0xB000, 0xB009)
    results["basic_upper_8000"] = {
        "first_32_bytes_hex": b8[:32].hex(),
        "b000_vectors": b8_b000_jmp,
        "b000_first_64_hex": b8[0x3000:0x3040].hex(),
        "last_64_bytes_hex": b8[-64:].hex()
    }

    # 3. Inspect KERNAL ($C000-$FFFF)
    # Screen Editor jump table at $C000
    editor_jmp = decode_jmp_table(kn, 0xC000, 0xC000, 0xC042)
    # C128 extended KERNAL jump table ($FF47-$FF80) and standard KERNAL jump table ($FF81-$FFF5)
    kernal_ext_jmp = decode_jmp_table(kn, 0xC000, 0xFF47, 0xFF81)
    kernal_std_jmp = decode_jmp_table(kn, 0xC000, 0xFF81, 0xFFF6)
    hw_vectors = {
        "FFFA_NMI": f"${word_le(kn, 0x3FFA):04X}",
        "FFFC_RESET": f"${word_le(kn, 0x3FFC):04X}",
        "FFFE_IRQ_BRK": f"${word_le(kn, 0x3FFE):04X}",
        "FFF6_SYSTEM_VECTOR": f"${word_le(kn, 0x3FF6):04X}",
        "FFF8_SYSTEM_VECTOR": f"${word_le(kn, 0x3FF8):04X}"
    }
    results["kernal_c000"] = {
        "editor_jump_table_c000": editor_jmp,
        "kernal_extended_jump_table_ff47": kernal_ext_jmp,
        "kernal_standard_jump_table_ff81": kernal_std_jmp,
        "hardware_vectors_fff6_ffff": hw_vectors
    }

    # 4. Inspect Z80 BIOS ($0000-$0FFF / KERNAL $D000-$DFFF)
    # Check Z80 RST vectors at $0000, $0008, $0010, $0018, $0020, $0028, $0030, $0038, and NMI at $0066
    z80_vectors = {}
    for rst in [0x0000, 0x0008, 0x0010, 0x0018, 0x0020, 0x0028, 0x0030, 0x0038, 0x0066]:
        z80_vectors[f"${rst:04X}"] = z8[rst:rst+8].hex()
    results["z80bios"] = {
        "rst_and_nmi_vectors": z80_vectors,
        "last_64_bytes_hex": z8[-64:].hex()
    }

    # 5. Inspect Character ROM (8192 bytes)
    # Compare halves and 2KB quarters
    q0 = ch[0x0000:0x0800] # $0000-$07FF (C64 Uppercase/Graphics)
    q1 = ch[0x0800:0x1000] # $0800-$0FFF (C64 Lowercase/Uppercase)
    q2 = ch[0x1000:0x1800] # $1000-$17FF (C128 Uppercase/Graphics)
    q3 = ch[0x1800:0x2000] # $1800-$1FFF (C128 Lowercase/Uppercase)

    def diff_quarters(qa, qb):
        diffs = []
        for char_idx in range(256):
            ca = qa[char_idx*8:(char_idx+1)*8]
            cb = qb[char_idx*8:(char_idx+1)*8]
            if ca != cb:
                diffs.append({
                    "char_index": char_idx,
                    "char_hex": f"0x{char_idx:02X}",
                    "qa_bytes": ca.hex(),
                    "qb_bytes": cb.hex()
                })
        return diffs

    q0_vs_q2 = diff_quarters(q0, q2)
    q1_vs_q3 = diff_quarters(q1, q3)

    results["character_rom_analysis"] = {
        "quarter_0_0000_07FF_sha256": __import__("hashlib").sha256(q0).hexdigest(),
        "quarter_1_0800_0FFF_sha256": __import__("hashlib").sha256(q1).hexdigest(),
        "quarter_2_1000_17FF_sha256": __import__("hashlib").sha256(q2).hexdigest(),
        "quarter_3_1800_1FFF_sha256": __import__("hashlib").sha256(q3).hexdigest(),
        "q0_vs_q2_differing_glyphs_count": len(q0_vs_q2),
        "q0_vs_q2_differing_glyphs": q0_vs_q2,
        "q1_vs_q3_differing_glyphs_count": len(q1_vs_q3),
        "q1_vs_q3_differing_glyphs": q1_vs_q3
    }

    with open(os.path.join(WORKSPACE, "REA", "EVIDENCE", "PHASE1", "segmentation_analysis.json"), "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2)

    print("Segmentation analysis complete.")
    print(f"Hardware vectors: {hw_vectors}")
    print(f"Character ROM Q0 vs Q2 differing glyphs: {len(q0_vs_q2)}")
    print(f"Character ROM Q1 vs Q3 differing glyphs: {len(q1_vs_q3)}")

if __name__ == "__main__":
    main()
