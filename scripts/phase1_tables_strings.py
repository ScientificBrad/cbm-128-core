#!/usr/bin/env python3
"""
Detailed table, string, and revision marker extraction across all C128 ROMs.
"""
import os
import json

WORKSPACE = r"D:\Emulation\C128"

def load_rom(name):
    with open(os.path.join(WORKSPACE, name), "rb") as f:
        return f.read()

def decode_highbit_table(data, start_off, end_off, base_addr):
    items = []
    cur = bytearray()
    item_start = start_off
    for off in range(start_off, end_off):
        b = data[off]
        if b == 0xFF or b == 0x00:
            if cur:
                items.append({
                    "offset": f"0x{item_start:04X}",
                    "cpu_addr": f"${base_addr+item_start:04X}",
                    "text": cur.decode("ascii", errors="replace"),
                    "terminated_by": f"0x{b:02X}"
                })
                cur = bytearray()
            break
        cur.append(b & 0x7F)
        if b & 0x80:
            items.append({
                "offset": f"0x{item_start:04X}",
                "cpu_addr": f"${base_addr+item_start:04X}",
                "text": cur.decode("ascii", errors="replace")
            })
            cur = bytearray()
            item_start = off + 1
    return items

def find_all_ascii_strings(data, base_addr, min_len=4):
    res = []
    cur = bytearray()
    start = 0
    for i, b in enumerate(data):
        if 0x20 <= b <= 0x7E or b in (0x0D,):
            if not cur:
                start = i
            cur.append(b)
        else:
            if len(cur) >= min_len:
                text = cur.decode("ascii", errors="replace").replace("\r", "\\r")
                if any(c.isalpha() for c in text):
                    res.append({
                        "offset": f"0x{start:04X}",
                        "cpu_addr": f"${base_addr+start:04X}",
                        "length": len(cur),
                        "text": text
                    })
            cur = bytearray()
    return res

def main():
    b4 = load_rom("basic-4000.318018-02.bin")
    b8 = load_rom("basic-8000.318019-02.bin")
    kn = load_rom("kernal.318020-03.bin")
    z8 = load_rom("z80bios.bin")

    # Find where "END", "FOR", "NEXT" are in b4
    idx_for = b4.find(b"END\xcdFOR\xceNEXT")
    if idx_for == -1:
        idx_for = b4.find(b"FOR")

    # Find where "TOO MANY FILES" is in b4
    idx_err = b4.find(b"TOO MANY FILE")

    # Find where "COMMODORE BASIC" is in b4
    idx_cbm = b4.find(b"COMMODORE")

    # Inspect trailing bytes of each ROM
    trailing_bytes = {
        "b4_7FFC_7FFF": [f"0x{x:02X}" for x in b4[0x3FFC:0x4000]],
        "b8_BFFC_BFFF": [f"0x{x:02X}" for x in b8[0x3FFC:0x4000]],
        "kn_CEFC_CFFF": [f"0x{x:02X}" for x in kn[0x0FFC:0x1000]],
        "kn_DFEC_DFFF": [f"0x{x:02X}" for x in kn[0x1FEC:0x2000]],
        "kn_FEFC_FF09": [f"0x{x:02X}" for x in kn[0x3EFC:0x3F0A]],
        "kn_FF80": f"0x{kn[0x3F80]:02X}"
    }

    # Check if sum of bytes in b4, b8, kn has any relationship to the trailing checksum bytes
    b4_sum_no_last = sum(b4[:-1]) & 0xFF
    b4_sum_all = sum(b4) & 0xFF
    b8_sum_no_last = sum(b8[:-1]) & 0xFF
    b8_sum_all = sum(b8) & 0xFF

    out = {
        "b4_for_offset": f"0x{idx_for:04X}" if idx_for != -1 else None,
        "b4_for_cpu": f"${0x4000+idx_for:04X}" if idx_for != -1 else None,
        "b4_err_offset": f"0x{idx_err:04X}" if idx_err != -1 else None,
        "b4_err_cpu": f"${0x4000+idx_err:04X}" if idx_err != -1 else None,
        "b4_cbm_offset": f"0x{idx_cbm:04X}" if idx_cbm != -1 else None,
        "b4_cbm_cpu": f"${0x4000+idx_cbm:04X}" if idx_cbm != -1 else None,
        "trailing_bytes": trailing_bytes,
        "checksum_byte_tests": {
            "b4_sum_mod256": f"0x{b4_sum_all:02X}",
            "b4_last_byte": f"0x{b4[-1]:02X}",
            "b8_sum_mod256": f"0x{b8_sum_all:02X}",
            "b8_last_byte": f"0x{b8[-1]:02X}"
        },
        "b4_strings": find_all_ascii_strings(b4, 0x4000, 4),
        "b8_strings": find_all_ascii_strings(b8, 0x8000, 4),
        "kn_strings": find_all_ascii_strings(kn, 0xC000, 4),
        "z8_strings": find_all_ascii_strings(z8, 0x0000, 4)
    }

    if idx_for != -1:
        out["b4_tokens_decoded"] = decode_highbit_table(b4, idx_for, idx_for + 0x500, 0x4000)
    if idx_err != -1:
        out["b4_errors_decoded"] = decode_highbit_table(b4, idx_err, idx_err + 0x400, 0x4000)

    with open(os.path.join(WORKSPACE, "REA", "EVIDENCE", "PHASE1", "tables_and_strings.json"), "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2)

    print(f"b4 FOR offset: {out['b4_for_cpu']}, ERR offset: {out['b4_err_cpu']}, CBM offset: {out['b4_cbm_cpu']}")
    print("Trailing bytes:", trailing_bytes)
    print(f"Tokens decoded: {len(out.get('b4_tokens_decoded', []))}, Errors decoded: {len(out.get('b4_errors_decoded', []))}")

if __name__ == "__main__":
    main()
